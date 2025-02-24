class Public::MapsController < ApplicationController
  def show
    @post = Post.find_by(id:params[:post_id])
    gon.latitude = @post.latitude
    gon.longitude = @post.longitude
  end
end
