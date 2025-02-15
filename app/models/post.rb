class Post < ApplicationRecord
  has_one_attached :post_image

  belongs_to :user
  #has_many :bookmarks, dependent: :destroy
  has_many :post_comments, dependent: :destroy

  enum posts_visibility_range: { post_public: 0, post_unlisted: 1, post_private:2 }

  validates :title, presence: true
  validates :visited_at, presence: true
end
