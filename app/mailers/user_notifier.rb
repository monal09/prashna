class UserNotifier < ApplicationMailer
	# do the needful
	default from: CONSTANTS[:email_form]

	def user_verification(user)
    @user = user
    mail to: @user.email, subject: 'Verify your email id'
	end

end
