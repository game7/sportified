class Admin::UsersController < Admin::AdminController

  before_action :load_user, only: [:update]

  def index
    @search = User.search(params[:q]) if params[:q].present?
  end

  def show
    @user = User.includes(:registrations, :vouchers).find(params[:id])
    @voucher = @user.vouchers.build
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
