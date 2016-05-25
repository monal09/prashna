class PasswordResetController < ApplicationController
  def new

    user = User.find_by(forgot_password_token: params[:token])
    @token = params[:token]
    if (!user) || (!user.valid_forgot_password_token?)
      flash[:notice] = "Invalid verification token"
      redirect_to root_path
    end

  end

  def create

    password = params[:password]
    if password == params[:confirm_password] && password.present?
      
      user = User.find_by(forgot_password_token: params[:token])

      if user && user.valid_forgot_password_token?
        user.reset_password!(password)
        flash[:notice] = "Password change successfully"
      else
        flash[:notice] = "Invalid verification token"
      end

      redirect_to root_path
    else

      flash[:alert] = "Password combination do not match"
      redirect_to :back
    end

  end

end
