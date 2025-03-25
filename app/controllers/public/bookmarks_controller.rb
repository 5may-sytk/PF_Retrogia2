class Public::BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user_bookmark, only: [:create]

  def create
    @post = Post.find(params[:post_id])
    @bookmark = current_user.bookmarks.new(post_id: @post.id)
    @bookmark.save
  end

  def bookmarked
    #@my_bookmark_posts = Kaminari.paginate_array(current_user.bookmarked_posts.sort_by { |post| post.favorites.find_by(user_id: current_user.id)&.created_at }.reverse).page(params[:page]).per(5)
    @my_bookmark_posts = current_user.bookmark_posts.includes(:bookmarks).order('bookmarks.created_at': :desc).page(params[:page]).per(5)
  end

  def destroy
    @post = Post.find(params[:post_id])
    @bookmark = current_user.bookmarks.find_by(post_id: @post.id)
    @bookmark.destroy
  end

  def reject_guest_user_bookmark
    if current_user.email == "guest@example.com"
    redirect_to request.referer, notice: 'ブックマークにはログインが必要です'
    end
  end

end
