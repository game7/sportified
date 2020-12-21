class Admin::Users::RegistrationsController < Admin::AdminController
  before_action :set_user, only: [:index, :create]

  def index
    @registrations = Registration.where(email: @user.email).order(created_at: :asc)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

end
