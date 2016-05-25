class UserNotifier < ApplicationMailer
	
  default from: CONSTANTS["email_from"]

  def email_verification(user)
    @user = user
    mail to: @user.email, subject: 'Welcome to Prashna, kindly verify your email to continue'
  end

end
