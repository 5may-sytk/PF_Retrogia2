class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user_comment, only: [:create]
  
  def create
    @post = Post.find(params[:post_id])
    @post_comment = current_user.post_comments.new(post_comment_params)
    @post_comment.post_id = @post.id 
    if @post_comment.save
      redirect_to public_post_post_comments_path(@post)
    else
      flash.now[:notice] = "コメントの投稿に失敗しました"
      redirect_to public_post_post_comments_path(@post)
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
    if @Post_comment.update(comment_params)
      redirect_to public_post_post_comments_path(@post)
    else
      flash.now[:notice] = "コメントの編集に失敗しました"
      redirect_to public_post_post_comments_path(@post)
    end
  end

  def update
  end

  def destroy
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.find(params[:id])
    @post_comment.destroy
  end

  private
  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end

  def reject_guest_user_comment
    @user = current_user
    if @user.email == "guest@example.com"
      redirect_to public_post_post_comments_path(@post) , notice: 'コメントにはログインが必要です'
    end
  end 
end
