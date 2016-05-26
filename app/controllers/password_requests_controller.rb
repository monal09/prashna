class PasswordRequestsController < ApplicationController
  before_action :ensure_anynomous

  def new
  end

  def create
    #FIXME_AB: verfied scope
    user = User.verified.where(email: params[:email]).first
    if user
      user.send_forgot_password_instructions
      flash[:notice] = "Password reset instructions has been sent to your registered email.
        Follow the instructions in the email to proceed"
      redirect_to root_path
    else
      redirect_to new_password_request_path, alert: "Invalid email"
    end
  end

end
