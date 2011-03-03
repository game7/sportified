class Admin::UsersController < Admin::AdminController
  
  def index
    @users = User.for_site(Site.current).entries
  end

end
