class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user_comment, only: [:create]
  before_action :is_matching_login_user, only: [:edit, :update]
  
  def create
    @post = Post.find(params[:post_id])
    @post_comment = current_user.post_comments.new(post_comment_params)
    @post_comment.post_id = @post.id 
    if @post_comment.save
      redirect_to public_post_post_comments_path(@post)
    else
      @post_comments = @post.post_comments
      flash.now[:notice] = "コメントの投稿に失敗しました"
      render "index"
    end
  end

  def index
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.new
    @post_comments = @post.post_comments.order(created_at: :desc).page(params[:page]).per(10)
  end

  def edit
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.find(params[:id])
  end

  def update
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.find(params[:id])
    if @post_comment.update(post_comment_params)
      redirect_to public_post_post_comments_path(@post)
    else
      flash.now[:notice] = "コメントの編集に失敗しました"
      render "edit"
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.find(params[:id])
    @post_comment.destroy
    redirect_to public_post_post_comments_path(@post)
  end

  private
  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end

  def reject_guest_user_comment
    @user = current_user
    @post = Post.find(params[:post_id])
    if @user.email == "guest@example.com"
      redirect_to public_post_post_comments_path(@post) , notice: 'コメントにはログインが必要です'
    end
  end 

  def is_matching_login_user
    @post_comment = PostComment.find(params[:id])
    @post = Post.find(params[:post_id])
    unless @post_comment.user == current_user
      redirect_to public_post_post_comments_path(@post)
    end
  end
  
end
