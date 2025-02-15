class Admin::SearchesController < ApplicationController


  def search
    @range = params[:range]
    @word = params[:word]
  
    if @range != "User"
      @posts = Post.where("title LIKE ?", "%#{@word}%")
      return
    end

    return if @word.blank?
  
    if @word.match(/\A[a-zA-Z0-9]{10}\z/)
      @users = User.where(unique_id: @word)
    else
      @users = User.where("name LIKE ?", "%#{@word}%")
    end
  end
end