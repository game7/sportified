require File.expand_path('../../app/controllers/passwordless/sessions_controller', Passwordless::Engine.called_from)

module Passwordless
  class SessionsController 
    before_action :redirect_https

  end
end