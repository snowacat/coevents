class AdminMailer < ActionMailer::Base
  default from: 'http://www.coevents.ru'

  def password_reset(admin)
    @admin = admin
    mail to: admin.email, subject: 'Password Reset'
  end
end
