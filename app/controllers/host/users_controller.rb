class Host::UsersController < Host::HostController
  
  def index
    @users = User.all.entries
  end

end
