class Admin::SearchesController < ApplicationController

  def search
    @word = params[:word]

    if params[:is_status] == "1"
      @users = User.where(is_active: false)
    else
      redirect_to admin_users_path
    end

    if @word.blank?
      redirect_to admin_users_path
    end

    if @word.match(/\A[a-zA-Z0-9]{10}\z/)
      @users = User.where(unique_id: @word)
    else
      @users = User.where("name LIKE ?", "%#{@word}%")
    end
  end
end