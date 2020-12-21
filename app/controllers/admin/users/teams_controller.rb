class Admin::Users::TeamsController < Admin::AdminController
  before_action :set_user, only: [:index, :create]

  def index
    @players = Player.includes(team: [:division, :season]).where(email: @user.email).order(id: :asc)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
