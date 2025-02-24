class Admin::PostsController < ApplicationController
  def index
    if params[:user_id].present?
      @user = User.find(params[:user_id])
      @posts = @user.posts.page(params[:page]).per(1)
      @posts_total_count = @posts.count
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @post = @user.posts
  end

  def update
    @user = User.find(params[:user_id])
    @post = @user.posts.find_by(id: params[:post_id])
    if @post.update(post_params)
      redirect_to admin_user_posts_path(@user)
    else
      flash.now[:notice] = "更新に失敗しました。"
      render :index
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @post = @user.posts
    @post.destroy
    redirect_to admin_user_posts_path(@user)
  end

  private
  def post_params
    params.require(:post).permit(:visibility)
  end
end
