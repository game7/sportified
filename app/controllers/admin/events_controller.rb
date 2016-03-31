require "chronic"
class Admin::EventsController < Admin::BaseLeagueController

  before_filter :mark_return_point, :only => [:new, :edit, :destroy]
  before_filter :add_events_breadcrumb
  before_filter :load_event, :only => [:edit, :update, :destroy]
  before_filter :find_season, :only => [:new, :create]
  before_filter :load_season_options, :only => [:new, :edit]
  before_filter :load_league_options, :only => [:new, :edit]
  before_filter :load_location_options, :only => [:new, :edit]
  before_filter :load_season_links, :only => [:index]

  def index

    @date = params[:date] ? Date.parse(params[:date]) : Date.current

    puts "date: #{@date}"
    puts "start: #{@date.at_beginning_of_week.beginning_of_day}"
    puts "end: #{@date.at_end_of_week.end_of_day}"
    @events = Event.all.includes(:location)
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

  def new
    if params[:clone]
      clone = Event.find(params[:clone])
      @event = clone.dup
    else
      @event = Event.new(:season => @season, :league_id => params[:league_id])
      @event.location_id = @location_options.first.id unless @location_options.empty?
    end
  end

  def edit
  end

  def create
    Chronic.time_class = Time.zone
    params[:event][:starts_on] = Chronic.parse(params[:event][:starts_on])
    @event = Event.new(event_params)
    if @event.save
      return_to_last_point :success => 'Event was successfully created.'
    else
      flash[:error] = 'Event could not be created.'
      load_season_options
      load_league_options
      load_location_options
      render :action => "new"
    end
  end

  def update
    @event = Event.find(params[:id])
    Chronic.time_class = Time.zone
    params[:event][:starts_on] = Chronic.parse(params[:event][:starts_on])
    if @event.update_attributes(event_params)
      return_to_last_point(:notice => 'Event was successfully updated.')
    else
      flash[:error] = 'Event could not be updated.'
      load_season_options
      load_league_options
      load_location_options
      render :action => "edit"
    end
  end

  def destroy
    @event.destroy
    return_to_last_point :success => 'Event has been deleted.'
  end


  private

  def event_params
    params.require(:event).permit(:season_id, :league_id, :starts_on, :duration,
      :all_day, :location_id, :summary, :description, :show_for_all_teams
    )
  end

  def add_events_breadcrumb
    add_breadcrumb 'Events', admin_events_path
  end

  def load_event
    @event = Event.find(params[:id])
  end

  def load_season_links
    @season_links = Season.all.order(:starts_on => :desc).each.collect do |s|
      [s.name, admin_events_path(:season_id => s.id, :date => params[:date])]
    end
    #@season_links.insert 0, ["All Seasons", admin_events_path(:date => params[:date])]
  end

  def load_season_options
    @season_options = Season.order(starts_on: :desc)
  end

  def load_league_options
    @league_options = @season.leagues.order(:name) if @season
    @league_options ||= []
  end

  def load_location_options
    @location_options = Location.order(:name).entries
  end

  def find_season
    @season = Season.find(params[:season_id]) if params[:season_id]
    @season ||= Season.most_recent()
  end

end
