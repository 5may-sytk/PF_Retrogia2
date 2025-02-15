# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :reject_end_user, only: [:create]

  protected

  def reject_end_user
    @user = User.find_by(name: params[:user][:name])
  
    return flash.now[:notice] = "該当ユーザーが見つかりません" unless @user
    return flash.now[:notice] = "パスワードが正しくありません" unless @user.valid_password?(params[:user][:password])
  
    if @user.is_active?
      flash.now[:notice] = "項目を入力してください"
    else
      flash.now[:notice] = "退会済みです。再度ご登録をお願いします"
      redirect_to new_user_registration_path
    end
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
