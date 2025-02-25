class Admin::PostsController < ApplicationController
  def index
    if params[:user_id].present?
      @user = User.find(params[:user_id])
      @posts = @user.posts.page(params[:page])
      @posts_total_count = @posts.count
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @post = Post.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    @post = @user.posts.find_by(id: params[:id])
    if @post.update(post_params)
      redirect_to admin_user_posts_path(@user)
    else
      flash.now[:notice] = "更新に失敗しました。"
      render :index
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @post = @user.posts.find_by(id: params[:id])
    @post.destroy
    redirect_to admin_user_posts_path(@user)
  end

  private
  def post_params
    params.require(:post).permit(:visibility)
  end
end
