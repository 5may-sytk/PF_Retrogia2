class Admin::PostsController < ApplicationController
  def index
    if params[:user_id].present?
      @user = User.find(params[:user_id])
      @posts = @user.posts.page(params[:page])
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @post = @user.posts
  end

  def update
  end

  def destroy
  end

  private
  def post_params
    params.require(:post).permit(:visibility)
  end
end
