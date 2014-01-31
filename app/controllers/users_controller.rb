class UsersController < ApplicationController

  def new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      log_in!(@user)
      redirect_to goals_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

end
