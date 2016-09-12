class Api::League::TeamsController < Api::BaseController

  def index
    render json: ::League::Team.all
  end

end
