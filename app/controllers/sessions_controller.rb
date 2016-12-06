class SessionsController < Devise::SessionsController
  before_action :redirect_https

end
