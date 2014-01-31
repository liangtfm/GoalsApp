class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )

    unless @user.nil?
      log_in!(@user)
      redirect_to goals_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def destroy
    log_out!
    redirect_to new_session_url
  end
end
