class SessionsController < Devise::SessionsController
  before_action :redirect_https

  def create
    puts '----- SESSION CREATE --------'
    super
  end

end
