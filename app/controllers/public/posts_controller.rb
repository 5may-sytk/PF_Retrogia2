class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.visibility = params[:post][:visibility]
    @post.user_id = current_user.id

    if @post.save
      redirect_to public_posts_path
    else
      flash.now[:notice] = "登録に失敗しました。"
      render :new
    end
  end

  def index
    if current_user
      @posts = Post.where(visibility: 0).or(Post.where(user_id: current_user.id)).order(created_at: :desc).page(params[:page]).per(15)
    else
      @posts = Post.where(visibility: 0).order(created_at: :desc).page(params[:page]).per(15)
    end
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
  end

  def edit
    @post = Post.find(params[:id])
    @user = @post.user
    unless @user.id == current_user.id
      redirect_to public_posts_path
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to public_post_path(@post.id)
    else
      flash.now[:notice] = "編集に失敗しました。"
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to public_user_path(current_user.id)
  end

  private
  def post_params
    params.require(:post).permit(:title, :contents, :address, :latitude, :longitude, :visited_at,:visibility,
    # :tags, 
    :post_image, :posts_visibility_ranges)
  end
end
