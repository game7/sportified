require "chronic"
class Admin::EventsController < Admin::AdminController

  before_action :mark_return_point, only: [:destroy]
  before_action :add_events_breadcrumb
  before_action :load_event, only: [:destroy]
  before_action :load_options, only: [:new, :create]

  def index
    @view = params[:view] || 'day'
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    Date.beginning_of_week = :sunday

    start_at = @date
    end_at = @date

    case @view
      when 'day'
        @title = @date.strftime('%A %B %-e, %Y')
      when 'fourday'
        start_at = @date.days_ago(1)
        end_at = @date.days_since(3)
        @title = "#{start_at.strftime('%B %-e')}-#{end_at.strftime('%-e %Y')}"
      when 'week'
        start_at = @date.at_beginning_of_week
        end_at = @date.at_end_of_week
        @title = "#{start_at.strftime('%B %-e')}-#{end_at.strftime('%-e %Y')}"
      when 'month'
        start_at = @date.at_beginning_of_month
        end_at = @date.at_end_of_month
        @title = @date.strftime('%B %Y')
    end

    @events = Event.includes(:location, :program, :taggings => :tag)
                   .after(start_at.beginning_of_day)
                   .before(end_at.end_of_day)
                   .order(:starts_on)

    @days = @events.group_by do |event|
      event.starts_on.strftime('%A %-m/%-e/%y')
    end


    @color_map = color_map(@events)

    respond_to do |format|
      format.html
      format.json { render json: @events }
    end

  end

  def destroy
    @event.destroy
    return_to_last_point :success => 'Event has been deleted.'
  end

  def assign
    @form = Admin::Events::AssignForm.new(Date.parse(params['event']['date']))
    @form.submit(params)
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

    def color_map(events)
      events.collect(&:color_key).uniq.reduce({}){|a,b| a[b] = colors[a.length]; a}
    end

    def colors
      %w{
        #b60205
        #d93f0b
        #fbca04
        #0e8a16
        #006b75
        #1d76db
        #0052cc
        #5319e7
        #e99695
        #f9d0c4
        #fef2c0
        #c2e0c6
        #bfdadc
        #c5def5
        #bfd4f2
        #d4c5f9
      }
    end

end
