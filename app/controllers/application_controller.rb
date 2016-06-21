class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include PermissionHelper

  helper_method :current_user, :signed_in?, :get_topics, :get_notifications

  def current_user
    @current_user ||= find_logged_in_user
  end

  def authenticate
    if !(signed_in?)
      redirect_to root_path
      flash[:notice] = "Please login to continue"
    end
  end

  def signed_in?
    !!current_user
  end

  def get_topics
    Topic.all
  end

  def get_notifications
    UserNotification.unread.where(user_id: current_user.id)
  end




  protected

  def find_logged_in_user
    if session[:user_id]
      User.verified.where(id: session[:user_id]).first
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
      user = User.verified.where(remember_me_token: token).first
      if user
        sign_in(user)
      end
      user
    end
  end

end
