class UsersController < ApplicationController

  def new
    
    if session[:user_id]
      redirect_to root_path
      flash[:notice] = "You are already looged in."
    end

    @user = User.new
	end
	
	def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to root_path,
          notice: "User #{@user.first_name} was successfully created. A verification
          mail has been sent to your user id #{@user.email}. Please verify your account to continue"  }
      else
        format.html { render action: 'new' }
      end
    end

	end

  def activate
    user = User.find_by(verification_token: params[:token])
    if user
      if user.check_token_expiry
        user.verify
        session[:user_id] = user.id
        flash[:notice] = "You have been successfully logged in"
      else
        flash[:notice] = "Verification token expired"
      end
    else
      flash[:notice] = "Innvalid verification token"
    end
    redirect_to root_path

  end
  
  private

  	def user_params
      params.require(:user).permit(:first_name, :last_name, :password, :email, :password_confirmation)
  	end

end
