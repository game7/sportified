class Next::Admin::LocationsController < Next::Admin::BaseController
  before_action :set_location, only: %i[show edit update]
  before_action :mark_return_point, only: %i[new edit]

  def index
    inertia props: {
      locations: Location.order(name: :asc),
      playing_surfaces: PlayingSurface.order(name: :asc),
      locker_rooms: LockerRoom.order(name: :asc)
    }
  end

  def show
    inertia props: {
      location: @location,
      playing_surfaces: @location.playing_surfaces.order(name: :asc),
      locker_rooms: @location.locker_rooms.order(name: :asc)
    }
  end

  def new
    inertia props: {
      location: Location.new
    }
  end

  def create
    if (@location = Location.new(location_params)).save
      return_to_last_point success: 'Location was successfully created.'
    else
      redirect_to new_next_admin_location_path, inertia: { errors: @location.errors },
                                                error: 'Location could not be created.'
    end
  end

  def edit
    inertia props: {
      location: @location
    }
  end

  def update
    if @location.update(location_params)
      return_to_last_point success: 'Location was successfully updated.'
    else
      redirect_to edit_next_admin_location_path(@location), inertia: { errors: @location.errors },
                                                            error: 'Location could not be updated.'
    end
  end

  private

  def set_location
    @location = Location.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:name, :short_name, :color)
  end
end
