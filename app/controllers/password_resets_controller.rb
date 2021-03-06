class PasswordResetsController < ApplicationController

  before_action :ensure_anynomous
  before_action :validate_token

  def new
  end

  def create
    if @user.change_password!(params[:password], params[:confirm_password])
      flash[:notice] = "Password changed successfully"
      redirect_to root_path
    else
      render "new"
    end
  end

  private

  def validate_token
    @user = User.verified.where(forgot_password_token: params[:token]).first

    if @user.nil? || !@user.valid_forgot_password_token?
      flash[:notice] = "Invalid verification token"
      redirect_to root_path
    end
  end

end
