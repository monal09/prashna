class SessionController < ApplicationController

  before_action :ensure_anynomous, except: :destroy

  def new
  end

  def create
    user = User.verified.where(email: params[:email]).first

    if user && user.authenticate(params[:password])
      sign_in( user )
      if params[:remember_me]
        user.generate_remember_me_token
        remember(user)
      end
      flash[:notice] = "You have been successfully logged in"
      redirect_to root_path
    else
      redirect_to login_url, alert: "Invalid user/password combination"
    end

  end

  def destroy
    current_user.reset_remember_me!
    reset_session
    cookies.delete :remember_token
    flash[:notice] = "You have been successfully logged out"
    redirect_to root_path
  end

end
