class RegistrationMailer < ApplicationMailer
  def confirmation_email(id, url)
    @registration = Registration.unscoped.includes(:tenant, variant: :product).find(id)
    @registration_url = url
    Time.use_zone(@registration.tenant.time_zone) do
      mail(to: @registration.email, subject: "Order Confirmation from #{@registration.tenant.name}")
    end
  end
end
