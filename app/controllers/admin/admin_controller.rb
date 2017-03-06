class Admin::AdminController < ApplicationController
  before_action :verify_admin
  #layout 'admin'

  def set_breadcrumbs
    super
    add_breadcrumb( "Admin", admin_root_path )
  end

end
