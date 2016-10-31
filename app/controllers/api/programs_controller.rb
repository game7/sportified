class Api::ProgramsController < Api::BaseController

  def index
    render json: ::Program.order(:name)
  end

end
