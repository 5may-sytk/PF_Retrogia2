class Public::MapsController < ApplicationController
  def show
    @post = Post.find_by(id:params[:post_id])
    gon.post = Post.find_by(id:params[:post_id])
  end

  def coming_soon
    @post = Post.find_by(id:params[:post_id])
  end
end
