class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :ensure_anynomous

  helper_method :current_user
  helper_method :signed_in?

  def current_user
    if signed_in?
      @current_user ||= User.find(session[:user_id])
    else
      @current_user = nil
    end

  end

  def signed_in?
    session[:user_id]
  end

  protected


  def sign_in(user)
    session[:user_id] = user.id
  end

  def ensure_anynomous
    if signed_in?
      redirect_to root_path
      flash[:notice] = "You are already logged in."
    end
  end

end
