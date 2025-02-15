class Admin::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to admin_user_path(@user.id)
    else
      flash.now[:notice] = "更新に失敗しました。"
      render :show
    end
  end

  def destroy
  end

  private
  def user_params
    params.require(:user).permit(:is_public, :is_active)
  end
  
end