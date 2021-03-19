

Passwordless.default_from_address = 'mailer@sportified.net'
Passwordless.redirect_back_after_sign_in = false

Passwordless.expires_at = lambda { 1.year.from_now } # How long until a passwordless session expires.
Passwordless.timeout_at = lambda { 1.month.from_now } # How long until a magic link expires.
