class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  #before_action :ensure_guest_user, only: [:create]

  def create
  end

  def followings
  end

  def followers
  end

  def destroy
  end

  private

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.email == "guest@example.com"
      redirect_to request.referer , notice: 'ゲストユーザーからフォローできません。'
    end
  end 
end
