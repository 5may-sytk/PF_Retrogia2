class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @favorite = current_user.favorites.find_or_create_by(post_id: @post.id)
  end

  def favorited
    @my_favorite_posts = current_user.favorited_posts.sort_by { |post| post.favorites.find_by(user_id: current_user.id).created_at }.reverse.take(5)
  end

  def destroy
    @post = Post.find(params[:post_id])
    @favorite = current_user.favorites.find_by(post_id: @post.id)
    @favorite.destroy if @favorite
  end

end
