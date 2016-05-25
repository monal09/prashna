class ApplicationMailer < ActionMailer::Base
  default from: CONSTANTS[:email_from]
  layout 'mailer'
end
