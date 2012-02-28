class Admin::AdminController < ApplicationController
  before_filter :verify_admin
  layout 'admin'

  def set_breadcrumbs
    super
    add_breadcrumb( "Admin", admin_root_path )
  end
  
  private
  
  def verify_admin
    redirect_to root_url unless current_user_is_host? || current_user_is_admin?
  end

end
