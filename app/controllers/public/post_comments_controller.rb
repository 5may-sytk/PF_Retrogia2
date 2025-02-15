class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @post = Post.find(params[:post_id])
    @post_comment = current_user.post_comments.new(post_comment_params)
    @post_comment.post_id = @post.id 
    if @post_comment.save
      flash[:notice] = "コメントを投稿しました"
      redirect_to public_post_post_comments_path(@post)
    else
      flash[:notice] = "コメントの投稿に失敗しました"
      redirect_to public_post_post_comments_path(@post)
    end
  end

  def index
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.new
    @post_comments = @post.post_comments
  end

  def destroy
  end

  private
  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
