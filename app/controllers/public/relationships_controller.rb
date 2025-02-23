class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user, only: [:create]

  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user.id)
  end
  
  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user.id)
  end
  
  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end
  
  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end

  private

  def ensure_guest_user
    @user = User.find(params[:user_id])
    if @user.email == "guest@example.com"
      redirect_to request.referer , notice: 'ゲストユーザーではフォローできません。'
    end
  end 
end
