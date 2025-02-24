class Public::MapsController < ApplicationController
  def show
    @posts = Post.select(:latitude, :longitude, :title)
  end
end
