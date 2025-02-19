class Post < ApplicationRecord
  has_one_attached :post_image

  belongs_to :user
  has_many :bookmarks, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  #has_many :post_tags
  #has_many :tags, through: :post_tags

  enum visibility: { post_public: 0, post_unlisted: 1, post_listed: 2, post_private:3 }

  validates :title, presence: true
  validates :visited_at, presence: true

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def bookmarked_by?(user)
    bookmarks.exists?(user_id: user.id)
  end

end
