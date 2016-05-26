class PasswordResetsController < ApplicationController

  before_actiaon :ensure_anynomous
  #FIXME_AB: You can use same for new action
  before_action :validate_token, only: :create

  def new
    #FIXME_AB: refactor
    user = User.find_by(forgot_password_token: params[:token])

    if (!user) || (!user.valid_forgot_password_token?)
      flash[:notice] = "Invalid verification token"
      redirect_to root_path
    end

  end

  def create
    #FIXME_AB: you already found user in before_action
    user = User.find_by(forgot_password_token: params[:token])
    user.password = params[:password]
    user.password_confirmation = params[:confirm_password]
    user.set_validate_password
    #FIXME_AB: if user.change_password!(p, cp) so that only one query fired.
    if user.save 
      flash[:notice] = "Password changed successfully"
      user.reset_password!(password)
      redirect_to root_path
    else
      #FIXME_AB: use render
      redirect_to :back
      #FIXME_AB: not need when using render
      flash[:alert] = "Failed to change password"
    end


  end

  private

  def validate_token
    #FIXME_AB: verified scope
    user = User.find_by(forgot_password_token: params[:token])

    if user.nil? || !user.valid_forgot_password_token?
      flash[:notice] = "Invalid verification token"
      redirect_to root_path
    end
  end

end
