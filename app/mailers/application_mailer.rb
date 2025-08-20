class ApplicationMailer < ActionMailer::Base
  default from: Rails.env.production? ? ENV['SMTP_USER_NAME'] : "no-reply@example.com"
  layout "mailer"
end
