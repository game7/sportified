class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.subscribe.subject
  #
  def subscribe(tenant, user)
    @tenant = tenant.name
    @name = user.full_name
    @url = users_schedule_url(user.id, host: tenant.secure_url)
    mail to: user.email,
         subject: "#{@tenant} Schedule for #{@name}"
  end
end
