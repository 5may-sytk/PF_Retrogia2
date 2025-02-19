class Public::BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user_bookmark, only: [:create]

  def create
    @post = Post.find(params[:post_id])
    @bookmark = current_user.bookmarks.new(post_id: @post.id)
    @bookmark.save
    redirect_to request.referer
  end

  def index
    @my_bookmark_posts = current_user.bookmarked_posts
  end

  def destroy
    @post = Post.find(params[:post_id])
    @bookmark = current_user.bookmarks.find_by(post_id: @post.id)
    @bookmark.destroy
    redirect_to request.referer
  end

  def reject_guest_user_bookmark
    if current_user.email == "guest@example.com"
    redirect_to public_posts_path, notice: 'ブックマークにはログインが必要です'
    end
  end
end