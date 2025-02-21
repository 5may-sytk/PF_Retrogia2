class Post < ApplicationRecord
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

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def bookmarked_by?(user)
    bookmarks.exists?(user_id: user.id)
  end

  def create_tags(input_tags)
    input_tags.each do |tag|                     
      new_tag = Tag.find_or_create_by(image_tags: tag) 
      tags << new_tag                            
    end
  end

  def update_tags(input_tags)
    registered_tags = tags.pluck(:image_tags) # すでに紐付けられているタグを配列化する
    new_tags = input_tags - registered_tags # 追加されたタグ
    destroy_tags = registered_tags - input_tags # 削除されたタグ
  
    new_tags.each do |tag| # 新しいタグをモデルに追加
      new_tag = Tag.find_or_create_by(image_tags: tag)
      tags << new_tag
    end
  
    destroy_tags.each do |tag| # 削除されたタグを中間テーブルから削除
      tag_id = Tag.find_by(image_tags: tag)
      destroy_post_tag = PostTag.find_by(tag_id: tag_id, post_id: id)
      destroy_post_tag.destroy
    end
  end
end
