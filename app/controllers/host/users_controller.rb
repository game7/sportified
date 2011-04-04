class Host::UsersController < Host::HostController
  
  before_filter :load_user, :only => :show

  def load_user
    @user = User.find(params[:id])
  end

  def set_breadcrumbs
    super
    add_breadcrumb( "Users", host_users_path )
  end
  
  def index
    @users = User.all.entries
  end

  def show
  end

end
