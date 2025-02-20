class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  #before_action :ensure_guest_user, only: [:create]

  def create
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end

  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  # フォローしている人一覧
  def follower
    user = User.find(params[:user_id])
    @users = user.followings
  end

  # フォローされている人一覧
  def followed
    user = User.find(params[:user_id])
    @users = user.followers
  end

  private

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.email == "guest@example.com"
      redirect_to request.referer , notice: 'ゲストユーザーではフォローできません。'
    end
  end 
end
