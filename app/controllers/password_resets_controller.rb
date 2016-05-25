class PasswordResetsController < ApplicationController

  before_action :ensure_anynomous
  before_action :validate_token, only: :create

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

    user = User.find_by(forgot_password_token: params[:token])
    user.password = params[:password]
    user.password_confirmation = params[:confirm_password]

    if user.save
      flash[:notice] = "Password change successfully"
      user.reset_password!(password)
      redirect_to root_path
    else
      flash[:alert] = "Password combination do not match"
      redirect_to :back
    end

  end

  private

  def validate_token
    user = User.find_by(forgot_password_token: params[:token])

    if !(user && user.valid_forgot_password_token?)
      flash[:notice] = "Invalid verification token"
      redirect_to root_path
    end

  end

end
