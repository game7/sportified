class Api::League::SeasonsController < Api::BaseController

  def index
    render json: ::League::Season.all
  end

end
