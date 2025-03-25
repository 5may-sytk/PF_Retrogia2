class Public::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @word = params[:word]

    if @word.blank?
      redirect_to posts_path
      return
    end

    if @range == "投稿"
      @posts = Post.where("title LIKE ? AND visibility = 0", "%#{@word}%")
    end

    if @range == "ユーザー"
      if @word.match(/\A[a-zA-Z0-9]{10}\z/)
        @users = User.where(unique_id: @word)
      else
        @users = User.where("name LIKE ?", "%#{@word}%")
      end
    end

    if @range == "タグ"
      #@posts = Post.joins(:post_tags).joins(:tags).where(tags: {"image_tags LIKE ?" => "%#{@word}%"})
      #@posts = Post.where(visibility: 0).joins(:post_tags).joins(:tags).where(tags.image_tags, @word)

      #最終決定
      #@posts = Post.where(visibility: 0).joins(:post_tags).joins(:tags).where("tags.image_tags LIKE ?", "%#{@word}%")
      #FBで提示されたもの
      #@posts = Post.where(visibility: 0).joins(:tags).where("tags.image_tags LIKE ?", "%#{@word}%").distinct
      @posts = Post.where(visibility: 0).joins(:post_tags).joins(:tags).where("tags.image_tags LIKE ?", "%#{@word}%").distinct
    end
  end
end