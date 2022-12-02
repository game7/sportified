class Next::Admin::General::EventsController < Next::Admin::BaseController
  before_action :set_event, only: %i[edit update]
  before_action :mark_return_point, only: %i[new edit]

  def new
    event = params[:clone] ? ::General::Event.find(params[:clone]).dup : ::General::Event.new
    event.build_recurrence

    inertia props: {
      event: event.as_json(include: [:recurrence]),
      locations: Location.order(name: :asc),
      tags: tags
    }
  end

  def create
    @event = ::General::Event.new(event_params)

    if @event.save
      return_to_last_point success: 'Event was successfully created.'
    else
      redirect_to new_next_admin_general_event_path, inertia: { errors: @event.errors }
    end
  end

  def edit
    inertia props: {
      event: @event,
      locations: Location.select(:id, :name).order(name: :asc),
      tags: tags
    }
  end

  def update
    if @event.update(event_params)
      return_to_last_point success: 'Event has been updated.'
    else
      redirect_to edit_next_admin_general_event_path(@event), inertia: { errors: @event.errors }
    end
  end

  private

  def set_event
    @event = ::General::Event.find(params[:id])
  end

  def event_params
    params.require(:general_event).permit(:starts_on, :duration, :all_day, :location_id,
                                          :summary, :description, :private,
                                          tag_list: [],
                                          recurrence_attributes: recurrence_attributes)
  end

  def recurrence_attributes
    %i[sunday monday tuesday wednesday thursday friday saturday sunday ending ends_on occurrence_count]
  end

  def tags
    ActsAsTaggableOn::Tag.for_tenant(Tenant.current).order(name: :asc)
  end
end
