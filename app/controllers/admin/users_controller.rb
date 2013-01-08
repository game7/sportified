class Admin::UsersController < Admin::AdminController
  
  before_filter :load_user, :only => :show

  def load_user
    @user = User.for_tenant(Tenant.current).find(params[:id])
  end

  def set_breadcrumbs
    super
    add_breadcrumb( "Users", admin_users_path )
  end
  
  def index
    @users = User.for_tenant(Tenant.current)
  end

  def show
    
  end

  def make_admin
    
  end

end
