class Next::Admin::League::EventsController < Next::Admin::BaseController
  before_action :mark_return_point, only: %i[new edit]
  before_action :set_event, only: %i[edit update]

  def new
    @event = params[:clone] ? ::League::Event.find(params[:clone]).dup : ::League::Event.new

    inertia props: options.merge({
                                   event: @event
                                 })
  end

  def create
    if (@event = ::League::Event.new(event_params)).save
      return_to_last_point success: 'Event was successfully created.'
    else
      redirect_to new_next_admin_league_event_path, inertia: { errors: @event.errors },
                                                    error: 'Event could not be created.'
    end
  end

  def edit
    inertia props: options.merge({
                                   event: @event
                                 })
  end

  def update
    if @event.update(event_params)
      return_to_last_point notice: 'Event was successfully updated.'
    else
      redirect_to edit_next_admin_league_event_path(@event), inertia: { errors: @event.errors },
                                                             error: 'Event could not be updated.'
    end
  end

  private

  def event_params
    Chronic.time_class = Time.zone
    params[:event][:starts_on] = Chronic.parse(params[:event][:starts_on])
    params.require(:event).permit(:program_id, :season_id, :division_id, :starts_on, :duration,
                                  :location_id, :summary, :description,
                                  :playing_surface_id)
  end

  def set_event
    @event = ::League::Event.find(params[:id])
  end

  def options
    @options ||= {
      programs: ::League::Program.order(:name).select(:id, :name),
      divisions: ::League::Division.order(:name).select(:id, :name, :program_id),
      seasons: ::League::Season.order(starts_on: :desc).select(:id, :name, :program_id),
      locations: Location.order(:name).select(:id, :name),
      playing_surfaces: PlayingSurface.order(:name).select(:id, :name, :location_id)
    }
  end
end
