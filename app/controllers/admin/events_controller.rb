require "chronic"
class Admin::EventsController < Admin::AdminController

  before_action :mark_return_point, only: [:destroy]
  before_action :add_events_breadcrumb
  before_action :load_event, only: [:destroy]
  before_action :load_options, only: [:new, :create]

  def index

    @date = params[:date] ? Date.parse(params[:date]) : Date.current

    puts "date: #{@date}"
    puts "start: #{@date.at_beginning_of_week.beginning_of_day}"
    puts "end: #{@date.at_end_of_week.end_of_day}"
    @events = Event.all.includes(:location, :program)
    @events = @events.after(@date.beginning_of_day).before(@date.end_of_day) unless params[:view]
    @events = @events.after(@date.days_ago(1).beginning_of_day).before(@date.days_since(3).end_of_day) if params[:view] == 'fourday'
    @events = @events.after(@date.at_beginning_of_week.beginning_of_day).before(@date.at_end_of_week.end_of_day) if params[:view] == 'week'
    @events = @events.after(@date.at_beginning_of_month.beginning_of_day).before(@date.at_end_of_month.end_of_day) if params[:view] == 'month'
    @events = @events.order(:starts_on)
    @days = @events.group_by do |event|
      event.starts_on.strftime('%A %-m/%-e/%y')
    end

    respond_to do |format|
      format.html
      format.json { render json: @events }
    end

  end

  def destroy
    @event.destroy
    return_to_last_point :success => 'Event has been deleted.'
  end

  private

    def event_params
      params.require(:event).permit(:program_id, :starts_on, :duration, :page_id,
                                      :all_day, :location_id, :summary, :description)
    end

    def add_events_breadcrumb
      add_breadcrumb 'Events', admin_events_path
    end

    def load_event
      @event = Event.find(params[:id])
    end

    def load_options
      @options = {
        pages: Page.options,
        programs: [],
        locations: Location.order(:name).pluck(:name, :id)
      }
    end

end
