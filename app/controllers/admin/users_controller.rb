class Admin::UsersController < Admin::AdminController

  before_action :load_user, only: [:show, :update]

  def index
    @users = Tenant.current.users
  end

  def show

  end

  def update
    @user.update_attributes(user_params)
  end

  private

    def user_params
      params.require(:user).permit(:admin, :operations)
    end

    def load_user
      @user = User.find(params[:id])
    end

    def set_breadcrumbs
      super
      add_breadcrumb( "Users", admin_users_path )
    end

end
