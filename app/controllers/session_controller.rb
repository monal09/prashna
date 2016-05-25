class SessionController < ApplicationController
  
  skip_before_action :ensure_anynomous, only: :destroy

  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.verified? && user.authenticate(params[:password])
      sign_in( user )
      flash[:notice] = "You have been successfully logged in"
      redirect_to root_path
    else
      redirect_to login_url, alert: "Invalid user/password combination"
    end

  end

  def destroy
    reset_session
    flash[:notice] = "You have been successfully logged out"
    redirect_to root_path
  end

end
