class Api::LocationsController < Api::BaseController

  def index
    render json: ::Location.all
  end

end
