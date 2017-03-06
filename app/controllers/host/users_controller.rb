class Host::UsersController < Host::HostController
  
  before_action :find_user, :only => :show

  def set_breadcrumbs
    super
    add_breadcrumb( "Users", host_users_path )
  end
  
  def index
    @users = User.all.entries
  end

  def show
  end
   
  private
  
    def find_user
      @user = User.find(params[:id])
    end

end
