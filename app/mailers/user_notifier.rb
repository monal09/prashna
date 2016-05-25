class UserNotifier < ApplicationMailer
	
  default from: CONSTANTS["email_from"]

  def user_verification(user)
    @user = user
    mail to: @user.email, subject: 'Verify your email id'
  end

end
