class GoalsController < ApplicationController
  before_filter :require_log_in
  before_filter :must_own_goal, only: [:edit, :update]

  def complete
    @goal = Goal.find(params[:goal_id])
    @goal.completed = true
    @goal.save!
    redirect_to goals_url
  end

  def new
  end

  def create
    @goal = Goal.new(params[:goal])
    @goal.user_id = current_user.id

    if @goal.save
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :new
    end
  end

  def show
    @goal = Goal.find(params[:id])
  end

  def index
    # @goals = Goal.all
    @my_goals = current_user.goals
    @other_peoples_goals = Goal
      .where(
        "(user_id <> :current_user_id) AND private_goal = 'f'",
        current_user_id: current_user.id
      )
  end

  def edit
    @goal = Goal.find(params[:id])
  end

  def update
    @goal = Goal.find(params[:id])

    if @goal.update_attributes(params[:goal])
      flash.now[:messages] = ["Goal Updated!"]
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :edit
    end
  end

  def destroy
    @goal = Goal.find(params[:id])

    @goal.destroy
    flash.now[:messages] = ["Goal Deleted!"]
    redirect_to goals_url
  end

  def must_own_goal
    owner_id = Goal.find(params[:id]).user_id
    redirect_to goals_url unless current_user.id == owner_id
  end

end
