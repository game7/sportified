class Api::League::ProgramsController < Api::BaseController

  def index
    render json: ::League::Program.all
  end

end
