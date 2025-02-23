class Public::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @word = params[:word]

    if @word.blank?
      redirect_to public_posts_path
      return
    end

    if @range == "投稿"
      @posts = Post.where("title LIKE ?", "%#{@word}%")

      if @users.exists?(is_public: false)
        redirect_to public_search_path
        return
      end
    end

    if @range == "ユーザー"
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

    if @range == "タグ"
      #@posts = Post.joins(:post_tags).joins(:tags).where(tags: {"image_tags LIKE ?" => "%#{@word}%"})
      @posts = Post.where(visibility: 0).joins(:post_tags).joins(:tags).where("tags.image_tags LIKE ?", "%#{@word}%")
      
      unless @posts.exists?
        redirect_to public_search_path
        return
      end
    end
  end
end