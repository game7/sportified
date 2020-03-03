class Admin::UserRolesController < Admin::AdminController
  
  before_action :load_user, :only => [:create, :destroy]

  def create
    @role = UserRole.admin(Tenant.current)
    @user.roles << @role
    @user.save
    flash[:notice] = "Role has been added"
  end

  def destroy
    @user.roles.find(params[:id]).delete
    flash[:notice] = "Role has been removed"
  end

  private
  
    def load_user
      @user = User.for_tenant(Tenant.current).find(params[:user_id])
    end

end
