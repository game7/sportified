class Admin::ProgramsController < Admin::AdminController
  def index
    @programs = ::Program.all.order(:name)
  end
end
