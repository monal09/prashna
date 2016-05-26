class UserNotifier < ApplicationMailer

  default from: CONSTANTS["email_from"]

  def email_verification(user)
    @user = user
    mail to: @user.email, subject: 'Welcome to Prashna, kindly verify your email to continue'
  end

  def password_reset(user)
    @user = user
    mail to: @user.email, subject: 'Prashna, Password reset instructions'
  end

end
