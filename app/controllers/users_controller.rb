class UsersController < ApplicationController

  def new
    #FIXME_AB: make a before action for this before_action :ensure_anonymous
    if current_user
      redirect_to root_path
      flash[:notice] = "You are already logged in."
    end

    @user = User.new
  end

  def create
    #FIXME_AB: ensure_anonymous
    @user = User.new(user_params)

    if @user.save
      redirect_to root_path
      flash[:notice] = "Signup successfull!!. A verification
          mail has been sent to your user id #{@user.email}. Please verify your account to continue"
    else
      render action: 'new'
    end

  end

  #FIXME_AB: should be named as verify / verification
  def activate
    user = User.find_by(verification_token: params[:token])

    #FIXME_AB: 
    # if user && user.valid_verification_tokenc?
    #   successfully
    # else
    #   unsucess
    # end

    if user
      if user.check_token_expiry
        user.verify
        session[:user_id] = user.id
        flash[:notice] = "You have been successfully logged in"
      else
        flash[:notice] = "Verification token expired"
      end
    else
      flash[:notice] = "Invalid verification token"
    end
    redirect_to root_path

  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :password, :email, :password_confirmation)
  end


end
