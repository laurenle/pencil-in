# Application controller
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  helper_method def logged_in?
    session[:user_id]
  end

  helper_method def current_user
    @user ||= User.find(session[:user_id]) if logged_in?
  end

  before_filter :require_login

  private

  def require_login
    redirect_to login_url unless current_user
  end
end
