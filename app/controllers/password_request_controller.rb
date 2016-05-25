class PasswordRequestController < ApplicationController

  def new
  end

  def create
    user = User.find_by(params[:email_id])
    if user && user.verified?
      flash[:notice] = "A password reset mail has been sent to youre registered emailid. 
        Follow the instructions there to proceed"
      user.send_forgot_password_instructions
      redirect_to root_path
    else
      redirect_to password_request_new_path, alert: "Invalid email_id"
    end
  end

end
