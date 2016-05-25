class SessionController < ApplicationController

	def new
	end

	def create
    user = User.find_by(email: params[:email])
    
    if user && user.authenticate(params[:password]) && user.verified?
      session[:user_id] = user.id
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
