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

  def show
    @user = User.find(params[:id], include: :goals)
  end

  def destroy
    @user = User.find(params[:id])
    if @user.admin?
      flash.now[:errors] = ["Can't delete admins!"]
      render :show
    else
      @user.destroy
      redirect_to admin_goals_url
    end
  end

end
