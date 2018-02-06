class Api::EventsController < Api::BaseController
  def index
    from = params[:from] ? Date.parse(params[:from]) : Date.current
    to = params[:to] ? Date.parse(params[:to]) : Date.current + 1.days
    puts from
    puts to
    events = Event.all.after(from).before(to).order(:starts_on).includes(:program, :location)
    render json: events
  end
end
