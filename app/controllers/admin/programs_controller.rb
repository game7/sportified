class Admin::ProgramsController < Admin::AdminController
  before_action :mark_return_point, :only => [:destroy]

  def index
    @programs = ::Program.all.order(:name)
  end

  def destroy
    Program.find(params[:id]).destroy
    return_to_last_point :success => 'Program has been deleted.'
  end

end
