class RegistrationMailer < ApplicationMailer

  def confirmation_email(tenant, registration)
    @registration = registration
    subject = "Order Confirmation from #{tenant.name}"
    mail(to: registration.user.email, subject: subject)
  end

end

