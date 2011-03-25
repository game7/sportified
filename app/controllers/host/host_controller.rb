class Host::HostController < ApplicationController
  authorize_resource

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  def set_breadcrumbs
    super
    add_breadcrumb( "Host", host_root_path )
  end
  
end
