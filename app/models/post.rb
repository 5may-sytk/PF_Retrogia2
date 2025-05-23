class Post < ApplicationRecord
  attr_accessor :image_tags

  has_one_attached :post_image

  belongs_to :user
  has_many :bookmarks, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  enum visibility: { post_public: 0, post_unlisted: 1, post_listed: 2, post_private:3 }

  validates :title, presence: true
  validates :visited_at, presence: true
  #validates :address, presence: true

  # geocode gem 使用
  geocoded_by :address
  after_validation :geocode

  after_create :create_auto_tags
  after_update :update_auto_tags

  def favorited_by?(user)
    favorites.exists?(user_id: user&.id)
  end

  def bookmarked_by?(user)
    bookmarks.exists?(user_id: user&.id)
  end

  def create_tags(input_tags)
    input_tags.each do |tag|                
      new_tag = Tag.find_or_create_by(image_tags: tag) 
      tags << new_tag                         
    end
  end

  def update_tags(input_tags)
    registered_tags = tags.pluck(:image_tags) # すでに紐付けられているタグを配列化
    new_tags = input_tags - registered_tags # 追加されたタグ
    destroy_tags = registered_tags - input_tags # 削除されたタグ
  
    new_tags.each do |tag| # 新しいタグをモデルに追加
      unless tags.pluck(:image_tags).include?(tag)
        new_tag = Tag.find_or_create_by(image_tags: tag)
        tags << new_tag
      end
    end
  
    destroy_tags.each do |tag| # 削除されたタグを中間テーブルから削除
      tag_id = Tag.find_by(image_tags: tag)
      destroy_post_tag = PostTag.find_by(tag_id: tag_id, post_id: id)
      destroy_post_tag.destroy
    end
  end

  def check_safe_search(results)
    error_message = []

    if results == false
      error_messages << "不適切要素を含む画像は投稿できません"
      return error_messages
    end
  end

  scope :visible_posts, -> (current_user) { 
    if current_user
      where(visibility: 0).or(where(user_id: current_user.id))
    else
      where(visibility: 0)
    end.order(created_at: :desc)
  }

  private

  def create_auto_tags
    input_tags = self.image_tags.split("#")    # tag_paramsをsplitメソッドを用いて配列に変換する
    self.create_tags(input_tags)   # create_tagsはpost.rbにメソッドを記載している

    #self.image_tags.each do |tag_name|
    #  tag = Tag.find_or_create_by(image_tags: tag_name)  # 既存タグを再利用 or 新規作成
    #  self.tags << tag unless self.tags.include?(tag)  # `PostTag` を作成
    #end
  end

  def update_auto_tags
    input_tags = self.image_tags.split("#")    # tag_paramsをsplitメソッドを用いて配列に変換する
    self.update_tags(input_tags)   # create_tagsはpost.rbにメソッドを記載している
  end
end
