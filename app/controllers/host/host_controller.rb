class Host::HostController < ApplicationController
  before_action :verify_host

  private 

  def set_breadcrumbs
    super
    add_breadcrumb( "Host", host_root_path )
  end
  
  def verify_host
    redirect_to root_url unless current_user_is_host?
  end

  
end
