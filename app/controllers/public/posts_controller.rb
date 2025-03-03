class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.visibility = params[:post][:visibility]
    @post.user_id = current_user.id

    # 画像解析
    #vision_tags = Vision.get_image_data(post_params[:post_image])
    if post_params[:post_image]
      @post.image_tags = Vision.get_image_data(post_params[:post_image])
    else
      flash.now[:notice] = "画像が投稿されていません。"
      render :new
      return
    end

    #input_tags = tag_params[:image_tags].split("#")    # tag_paramsをsplitメソッドを用いて配列に変換する
    #@post.create_tags(input_tags)   # create_tagsはpost.rbにメソッドを記載している

    if @post.save
      redirect_to public_posts_path

      #vision_tags.each do |tag_name|
      #  tag = Tag.find_or_create_by(image_tags: tag_name)  # 既存タグを再利用 or 新規作成
      #  @post.tags << tag unless @post.tags.include?(tag)  # `PostTag` を作成
      #end
    else
      flash.now[:notice] = "登録に失敗しました。"
      render :new
    end
  end

  def index
    if current_user
      @posts = Post.where(visibility: 0).or(Post.where(user_id: current_user.id)).order(created_at: :desc).page(params[:page])
    else
      @posts = Post.where(visibility: 0).order(created_at: :desc).page(params[:page])
    end
    
    @post = Post.new
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
    unless post_params[:post_image]
      flash.now[:notice] = "画像が投稿されていません。"
      render :edit
      return
    end

    if @post.update(post_params)
      input_tags = tag_params[:image_tags].split("#")
      @post.update_tags(input_tags)
      redirect_to public_post_path(@post.id)
    else
      flash.now[:notice] = "編集に失敗しました。"
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to public_posts_path
  end

  private
  def post_params
    params.require(:post).permit(:title, :contents, :address, :latitude, :longitude, 
                                 :visited_at,:visibility,:post_image, :posts_visibility_ranges, :image_tags)
  end

  def tag_params # tagに関するストロングパラメータ
    params.require(:post).permit(:image_tags)
  end
end
