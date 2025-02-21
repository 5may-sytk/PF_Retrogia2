class Public::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @word = params[:word]
  
    if @range != "ユーザー"
      @posts = Post.where("title LIKE ?", "%#{@word}%")

      unless @posts.where.not(visibility: 0).exists?
        redirect_to public_search_path
        return
      end
    end
  
    if @word.blank?
      redirect_to public_posts_path
      return
    end
  
    if @word.match(/\A[a-zA-Z0-9]{10}\z/)
      @users = User.where(unique_id: @word)
    else
      @users = User.where("name LIKE ?", "%#{@word}%")
    end
  
    if @users.exists?(is_public: false)
      redirect_to public_search_path
      return
    end
  end
end