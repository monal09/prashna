class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :signed_in?

  def current_user
    @current_user ||= find_logged_in_user
  end

  def signed_in?
    !!current_user
  end

  protected

  def find_logged_in_user
    if session[:user_id]
      #FIXME_AB: use verified scope
      User.find(session[:user_id])
    else
      sign_in_from_remember_token
    end    
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    cookies.permanent[:remember_token] = user.remember_me_token
  end

  def ensure_anynomous
    if signed_in?
      flash[:alert] = "You are already logged in."
      redirect_to root_path
    end
  end

  def sign_in_from_remember_token
    if cookies[:remember_token].present?
      token = cookies[:remember_token]
      #FIXME_AB: User.verified.find_by
      user = User.find_by(remember_me_token: token)
      #FIXME_AB: once you use verified scope you don't need to check it here
      if user && user.verified?
        sign_in(user)
      end
      user
    end
  end

end
