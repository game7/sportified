class Host::UsersController < Host::HostController

  def set_breadcrumbs
    super
    add_breadcrumb( "Users", host_users_path )
  end
  
  def index
    @users = User.all.entries
  end

end
