class Next::Admin::Locations::LockerRoomsController < Next::Admin::BaseController
  before_action :mark_return_point, only: %i[new edit destroy]

  def new
    location = Location.find(params[:location_id])
    locker_room = location.locker_rooms.build

    inertia props: {
      location: location,
      locker_room: locker_room
    }
  end

  def create
    location = Location.find(params[:location_id])

    if (locker_room = location.locker_rooms.build(locker_room_params)).save
      return_to_last_point success: 'Locker Room has been created.'
    else
      redirect_to new_next_admin_location_locker_room_path(location), inertia: { errors: locker_room.errors },
                                                                      error: 'Locker Room could not be created.'
    end
  end

  def edit
    locker_room = LockerRoom.find(params[:id])

    inertia props: {
      location: locker_room.location,
      locker_room: locker_room
    }
  end

  def update
    locker_room = LockerRoom.find(params[:id])

    if locker_room.update(locker_room_params)
      return_to_last_point success: 'Locker Room has been updated.'
    else
      redirect_to edit_next_admin_locker_room_path(locker_room), inertia: { errors: locker_room.errors },
                                                                 error: 'Locker Room could not be updated.'
    end
  end

  def destroy
    locker_room = LockerRoom.find(params[:id])

    if locker_room.destroy
      return_to_last_point success: 'Locker Room has been deleted.'
    else
      return_to_last_point error: 'Locker Room could not be deleted.'
    end
  end

  private

  def locker_room_params
    params.require(:locker_room).permit(:name, :auto_assign)
  end
end
