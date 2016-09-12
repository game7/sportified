class Api::League::DivisionsController < Api::BaseController
  def index
    render json: ::League::Division.all
  end
end
