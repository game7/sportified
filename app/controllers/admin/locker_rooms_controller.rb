class Admin::LockerRoomsController < Admin::AdminController
  before_action :mark_return_point, only: %i[new edit destroy]
  before_action :set_locker_room, only: %i[edit update destroy]
  before_action :set_location, only: %i[new create]

  # GET /locker_rooms/new
  def new
    @locker_room = LockerRoom.new
  end

  # GET /locker_rooms/1/edit
  def edit; end

  # POST /locker_rooms
  def create
    @locker_room = LockerRoom.new(locker_room_params)
    @locker_room.location = @location

    if @locker_room.save
      return_to_last_point notice: 'Locker room was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /locker_rooms/1
  def update
    if @locker_room.update(locker_room_params)
      return_to_last_point notice: 'Locker room was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /locker_rooms/1
  def destroy
    @locker_room.destroy
    return_to_last_point notice: 'Locker room was successfully destroyed.'
  end

  private

  def set_locker_room
    @locker_room = LockerRoom.find(params[:id])
  end

  def set_location
    @location = Location.find(params[:location_id])
  end

  def locker_room_params
    params[:locker_room].permit(:name, :parent_id, :auto_assign)
  end
end
