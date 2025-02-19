class Admin::SearchesController < ApplicationController
  def search
    @word = params[:word]

    if @word.blank? && params[:is_status] == "1"
      @users = User.where(is_active: false)
    elsif @word.blank? && params[:is_status] == "0"
      redirect_to admin_users_path
    elsif @word =~ /\A[a-zA-Z0-9]{10}\z/
      @users = User.where(unique_id: @word)
    else
      @users = User.where("name LIKE ?", "%#{@word}%")
    end
  end
end