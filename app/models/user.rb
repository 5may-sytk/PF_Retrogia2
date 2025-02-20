class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         authentication_keys: [:name]

  
          validates :name, presence: true
          # 名前を日本語に限定
          validates :name, format: { with: /\A[A-Za-zぁ-んァ-ヶー一-龠]+\z/, message: "は日本語で入力してください" }
          validates :introduction, length: { maximum: 100 }


  has_many :posts
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  # フォローしているユーザーとのアクティブなリレーションシップ
  has_many :active_relationships, class_name: "Relationship", 
                                  foreign_key: "follower_id", dependent: :destroy
  # フォローされているユーザーとのパッシブなリレーションシップ
  has_many :passive_relationships, class_name: "Relationship", 
                                    foreign_key: "followed_id", dependent: :destroy
  # フォローしているユーザーとの関連付け
  has_many :followings, through: :active_relationships, source: :follower
  # フォローされているユーザーとの関連付け
  has_many :followers, through: :passive_relationships, source: :followed

  has_one_attached :user_image

  after_update :update_posts_visibility, if: :is_public_changed_to_false?
      
  
  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end


  def favorited_posts
    self.favorites.includes(:post).map(&:post)
  end

  def bookmarked_posts
    self.bookmarks.includes(:post).map(&:post)
  end


  def follow(user_id)
    active_relationships.create(followed_id: user_id)
  end
			
  # フォローを外す
  def unfollow(user_id)
    active_relationships.find_by(followed_id: user_id).destroy
  end
			
  # すでにフォローしているのか確認
  def following?(user)
    followings.include?(user)
  end

  private
  def is_public_changed_to_false?
    is_public_before_last_save && !is_public
  end

  def update_posts_visibility
    self.posts.update_all(visibility: 3)
  end

end
