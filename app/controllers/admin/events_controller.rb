require "chronic"
class Admin::EventsController < Admin::BaseLeagueController
  
  before_filter :mark_return_point, :only => [:new, :edit, :destroy]
  before_filter :add_events_breadcrumb  
  before_filter :load_event, :only => [:edit, :update, :destroy]
  before_filter :find_season, :only => [:index, :new, :create]
  before_filter :load_season_options, :only => [:new, :edit]
  before_filter :load_league_options, :only => [:new, :edit]
  before_filter :load_venue_options, :only => [:new, :edit]     
  before_filter :load_season_links, :only => [:index]
  before_filter :load_events, :only => [:index]

  def index
  end

  def new
    @event = Event.new(:season => @season, :league_id => params[:league_id])
    @event.venue_id = @venue_options[0].id if @venue_options.count
  end

  def edit
  end

  def create
    @event = Event.new(params[:event])
    if @event.save
      return_to_last_point :success => 'Event was successfully created.'
    else
      flash[:error] = 'Event could not be created.'
      load_season_options
      load_league_options
      load_venue_options
      render :action => "new"
    end
  end

  def update
    @event = Event.find(params[:id])
    params[:event][:starts_on] = Chronic.parse(params[:event][:starts_on])
    if @event.update_attributes(params[:event])
      return_to_last_point(:notice => 'Event was successfully updated.')
    else
      flash[:error] = 'Event could not be updated.'
      load_season_options
      load_league_options      
      load_venue_options     
      render :action => "edit"
    end
  end

  def destroy
    @event.destroy
    return_to_last_point :success => 'Event has been deleted.'
  end
  
  
  private
  
  def add_events_breadcrumb
    add_breadcrumb 'Events', admin_events_path  
  end

  def load_event
    @event = Event.find(params[:id])   
  end

  def load_season_links
    @season_links = Season.all.desc(:starts_on).each.collect do |s|
      [s.name, admin_events_path(:season_id => s.id, :date => params[:date])]
    end
    #@season_links.insert 0, ["All Seasons", admin_events_path(:date => params[:date])]
  end
  
  def load_season_options
    @season_options = Season.desc(:starts_on)
  end  

  def load_league_options
    @league_options = @season.leagues.asc(:name) if @season
    @league_options ||= []
  end

  def load_venue_options
    @venue_options = Venue.asc(:name).entries
  end

  def find_season
    @season = Season.find(params[:season_id]) if params[:season_id]
    @season ||= Season.most_recent()
  end

  def load_events
    
    unless @season
      @date = params[:date] ? Date.parse(params[:date]) : Date.current
      @days_in_future = 14
      @days_in_past = 7
      @start_date = @date - @days_in_past - 1
      @end_date = @date + @days_in_future + 1
      @next_date = @date + @days_in_future + @days_in_past
      @prev_date = @date - @days_in_future - @days_in_past
    end

    @events = Event.all    
    @events = @events.for_season(@season) if @season
    @events = @events.between(@start_date, @end_date) unless @division.present? || @season.present?
    @events = @events.asc(:starts_on)    
  end  

end