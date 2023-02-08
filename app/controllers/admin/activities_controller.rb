class Admin::ActivitiesController < Admin::AdminController
  before_action :mark_return_point, only: %i[new edit destroy]
  before_action :add_breadcrumbs
  before_action :find_activity, only: %i[edit update destroy]

  def new
    @activity = Activity.new
  end

  def create
    @activity = Activity.new(activity_params)
    if @activity.save
      return_to_last_point success: 'Activity was successfully created.'
    else
      flash[:error] = 'Activity could not be created'
      render action: 'new'
    end
  end

  def edit; end

  def update
    if @activity.update(activity_params)
      return_to_last_point success: 'Activity was successfully updated.'
    else
      flash[:error] = 'Activity could not be updated.'
      render action: 'edit'
    end
  end

  def destroy
    @activity.destroy
    return_to_last_point success: 'activity has been deleted.'
  end

  private

  def activity_params
    params.required(:activity).permit(:name, :description)
  end

  def add_breadcrumbs
    add_breadcrumb 'Programs', admin_programs_path
  end

  def find_activity
    @activity = Activity.find(params[:id])
  end
end
