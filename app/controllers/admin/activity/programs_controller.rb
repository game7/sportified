class Admin::Activity::ProgramsController < Admin::AdminController
  before_filter :mark_return_point, :only => [:new, :edit, :destroy]
  before_filter :add_breadcrumbs
  before_filter :find_activity, :only => [:edit, :update, :destroy]

  def new
    @activity = ::Activity::Program.new
  end

  def create
    @activity = ::Activity::Program.new(program_params)
    if @activity.save
      return_to_last_point :success => 'Activity was successfully created.'
    else
      flash[:error] = "Activity could not be created"
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @activity.update_attributes(program_params)
      return_to_last_point :success => 'Activity was successfully updated.'
    else
      flash[:error] = "Activity could not be updated."
      render :action => "edit"
    end
  end

  def destroy
    @activity.destroy
    return_to_last_point :success => 'activity has been deleted.'
  end

  private

  def program_params
    params.required(:program).permit(:name, :description)
  end

  def add_breadcrumbs
    add_breadcrumb 'Programs', admin_programs_path
  end

  def find_activity
    @activity = ::Activity::Program.find(params[:id])
  end

end
