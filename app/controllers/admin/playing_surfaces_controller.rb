class Admin::PlayingSurfacesController < Admin::AdminController

  before_action :mark_return_point, only: [:new, :edit, :destroy]
  before_action :set_playing_surface, only: [:edit, :update, :destroy]
  before_action :set_location, only: [:new, :create]

  # GET /playing_surfaces/new
  def new
    @playing_surface = PlayingSurface.new
  end

  # GET /playing_surfaces/1/edit
  def edit
  end

  # POST /playing_surfaces
  def create
    @playing_surface = PlayingSurface.new(playing_surface_params)
    @playing_surface.location = @location

    if @playing_surface.save
      return_to_last_point notice: 'Playing surface was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /playing_surfaces/1
  def update
    if @playing_surface.update(playing_surface_params)
      return_to_last_point notice: 'Playing surface was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /playing_surfaces/1
  def destroy
    @playing_surface.destroy
    return_to_last_point  notice: 'Playing surface was successfully destroyed.'
  end

  private

    def set_playing_surface
      @playing_surface = PlayingSurface.find(params[:id])
    end

    def set_location
      @location = Location.find(params[:location_id])
    end

    def playing_surface_params
      params[:playing_surface].permit(:name)
    end
end
