class SessionsController < ApplicationController
  def setup
    request.env['omniauth.strategy'].client_id = '109262979133564'
    request.env['omniauth.strategy'].client_secret = '258cba5e2120cde7bc3818ea186e1263'
    render :text => "Setup complete.", :status => 404    
  end
end
