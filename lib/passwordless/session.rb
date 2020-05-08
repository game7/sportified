require File.expand_path('../../app/models/passwordless/session', Passwordless::Engine.called_from)

module Passwordless
  class Session
    include Sportified::TenantScoped

  end
end
