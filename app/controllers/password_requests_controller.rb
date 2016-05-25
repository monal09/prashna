class PasswordRequestsController < ApplicationController
  #FIXME_AB: plural
  before_action :ensure_anynomous

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.verified?
      user.send_forgot_password_instructions
      flash[:notice] = "A password reset mail has been sent to youre registered emailid.
        Follow the instructions there to proceed"
      redirect_to root_path
    else
      redirect_to new_password_requests_path, alert: "Invalid email"
    end
  end

end
