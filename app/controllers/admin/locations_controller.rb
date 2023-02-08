class Admin::LocationsController < Admin::BaseLeagueController
  before_action :mark_return_point, only: %i[new edit destroy]
  before_action :add_locations_breadcrumb
  before_action :load_location, only: %i[show edit update destroy]

  def index
    @locations = Location.order(:name)
  end

  def show; end

  def new
    @location = Location.new
    add_breadcrumb 'New'
  end

  def edit; end

  def create
    @location = Location.new(location_params)
    if @location.save
      return_to_last_point success: 'Location was successfully created.'
    else
      flash[:error] = 'Location could not be created'
      render action: 'new'
    end
  end

  def update
    if @location.update(location_params)
      return_to_last_point success: 'Location was successfully updated.'
    else
      flash[:error] = 'Location could not be updated'
      render action: 'edit'
    end
  end

  def destroy
    @location.destroy
    return_to_last_point success: 'Location has been deleted.'
  end

  private

  def location_params
    params.required(:location).permit(:name, :short_name)
  end

  def add_locations_breadcrumb
    add_breadcrumb 'Location', admin_locations_path
  end

  def load_location
    @location = Location.find(params[:id])
    add_breadcrumb @location.name
  end
end
