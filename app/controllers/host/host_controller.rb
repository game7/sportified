class Host::HostController < ApplicationController
  load_and_authorize_resource

  def current_ability
    @current_ability ||= HostAbility.new(current_user)
  end
  
end
