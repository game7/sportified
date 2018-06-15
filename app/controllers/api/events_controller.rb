class Api::EventsController < Api::BaseController

  class EventsResponse

    alias :read_attribute_for_serialization :send

    attr_reader :events

    def initialize(events)
      @events = events
    end

  end

  def index
    from = params[:from] ? Date.parse(params[:from]) : Date.current
    to = params[:to] ? Date.parse(params[:to]) : Date.current + 1.days
    events = Event.all.after(from).before(to).order(:starts_on).includes(:program, :location, taggings: :tag)
    # render json: events
    # render json: EventsResponse.new(events), include: ['events', 'events.tags']
    render json: events, include: [:location, :program, :tags]
  end

end
