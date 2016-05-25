class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :signed_in?

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    else
      @current_user = nil
    end

  end

  def signed_in?
    !!current_user
  end

  protected


  def sign_in(user)
    session[:user_id] = user.id
  end

  def ensure_anynomous
    if signed_in?
      flash[:notice] = "You are already logged in."
      redirect_to root_path
    end
  end

end
