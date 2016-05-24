class ApplicationMailer < ActionMailer::Base
	# extract this email in a application.yml file and use constant.rb to set env specific constants as discussed
  default from: CONSTANTS[:email_from]
  layout 'mailer'
end
