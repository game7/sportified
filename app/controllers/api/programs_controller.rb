class Api::ProgramsController < ApplicationController

  def index
    render json: ::Program.order(:name)
  end

end
