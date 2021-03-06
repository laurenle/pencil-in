# Session controller
class SessionsController < ApplicationController
  skip_before_filter :require_login

  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user.nil? || @user.password != params[:password]
      flash[:error] = 'No matching email/password found.'
      render :new
    else
      session[:user_id] = @user.id
      redirect_to tasks_path
    end
  end

  def destroy
    reset_session
    redirect_to root_url
  end
end
