class OmniauthCallbacksController < ApplicationController

  def stripe_connect
    raise request.env["omniauth.auth"].to_yaml
  end

end
