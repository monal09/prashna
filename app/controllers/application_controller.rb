class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :find_remembered_user

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

  def remember(user)
    cookies.permanent[:remember_token] = user.remember_me_token
  end

  def ensure_anynomous
    if signed_in?
      flash[:notice] = "You are already logged in."
      redirect_to root_path
    end
  end

  def find_remembered_user
    if cookies[:remember_token]
      token = cookies[:remember_token]
      user = User.find_by(remember_me_token: token)
      if user && user.verified?
        sign_in(user)
      end
    end
  end

end
