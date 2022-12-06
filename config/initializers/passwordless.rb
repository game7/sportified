Passwordless.default_from_address = 'mailer@sportified.net'
Passwordless.redirect_back_after_sign_in = true

Passwordless.expires_at = -> { 1.year.from_now } # How long until a passwordless session expires.
Passwordless.timeout_at = -> { 1.month.from_now } # How long until a magic link expires.

Rails.configuration.to_prepare do
  Passwordless::Session.class_eval do
    include Sportified::TenantScoped
  end
  
  Passwordless::SessionsController.class_eval do
    before_action :redirect_https

    def create
      @resource = find_authenticatable
      session = build_passwordless_session(@resource)

      if session.save
        if Passwordless.after_session_save.arity == 2
          Passwordless.after_session_save.call(session, request)
        else
          Passwordless.after_session_save.call(session)
        end
        ahoy.authenticate(session.authenticatable)
        redirect_to send(Passwordless.mounted_as).token_sign_in_url(session.token) if Rails.env.development?
      else
        render
      end
    end
  end
end
