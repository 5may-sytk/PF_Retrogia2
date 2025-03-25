class Public::MapsController < ApplicationController
  before_action :authenticate_user!
  def show
    @post = Post.find_by(id:params[:post_id])
    #gon.post = Post.find_by(id:params[:post_id])
  end
end
