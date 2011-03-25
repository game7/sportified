class Admin::UsersController < Admin::AdminController

  def set_breadcrumbs
    super
    add_breadcrumb( "Users", admin_users_path )
  end
  
  def index
    @users = User.for_site(Site.current).entries
  end

end
