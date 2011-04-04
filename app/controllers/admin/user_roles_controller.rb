class Admin::UserRolesController < Admin::AdminController
  
  before_filter :load_user, :only => [:create, :destroy]

  def load_user
    @user = User.for_site(Site.current).find(params[:user_id])
  end

  def create
    @role = UserRole.site_admin(Site.current)
    @user.roles << @role
    @user.save
    flash[:notice] = "Role has been added"
  end

  def destroy
    @user.roles.find(params[:id]).delete
    flash[:notice] = "Role has been removed"
  end

end
