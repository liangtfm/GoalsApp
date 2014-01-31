class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  def log_in!(user)
    session[:session_token] = user.reset_session_token!
    @current_user = user
  end

  def current_user
    return nil if session[:session_token].nil?

    @current_user ||= User.find_by_session_token(session[:session_token])
  end

  def log_out!
    current_user.try(:reset_session_token!)
    session[:session_token] = nil
  end

  def require_log_in
    redirect_to new_session_url unless current_user
  end
end
