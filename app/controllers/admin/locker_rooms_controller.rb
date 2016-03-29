class Admin::LockerRoomsController < ApplicationController

  before_action :mark_return_point, only: [:new, :edit, :destroy]
  before_action :set_locker_room, only: [:show, :edit, :update, :destroy]
  before_action :set_location, only: [:new, :create, :edit, :update]
  before_action :get_playing_surface_options, only: [:new, :edit]
  before_action :get_preference_options, only: [:new, :edit]

  # GET /locker_rooms
  def index
    @locker_rooms = LockerRoom.all
  end

  # GET /locker_rooms/1
  def show
  end

  # GET /locker_rooms/new
  def new
    @locker_room = LockerRoom.new
  end

  # GET /locker_rooms/1/edit
  def edit
  end

  # POST /locker_rooms
  def create
    @locker_room = LockerRoom.new(locker_room_params)
    @locker_room.location = @location

    if @locker_room.save
      return_to_last_point notice: 'Locker room was successfully created.'
    else
      puts @locker_room.errors.to_json
      get_playing_surface_options
      get_preference_options
      render :new
    end
  end

  # PATCH/PUT /locker_rooms/1
  def update
    if @locker_room.update(locker_room_params)
      return_to_last_point notice: 'Locker room was successfully updated.'
    else
      get_playing_surface_options
      get_preference_options
      render :edit
    end
  end

  # DELETE /locker_rooms/1
  def destroy
    @locker_room.destroy
    return_to_last_point notice: 'Locker room was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_locker_room
      @locker_room = LockerRoom.find(params[:id])
    end

    def set_location
      @location = Location.find(params[:location_id])
    end

    def get_playing_surface_options
      @playing_surfaces = @location.facilities.playing_surfaces.order(:name)
    end

    def get_preference_options
      @preferences = [['Home Team', 'HOME'], ['Away Team', 'AWAY']]
    end

    # Only allow a trusted parameter "white list" through.
    def locker_room_params
      params[:locker_room].permit(:name, :parent_id, :preference)
    end
end
