class Admin::EventsController < Admin::BaseLeagueController
  
  before_filter :mark_return_point, :only => [:new, :edit, :destroy]
  
  before_filter :add_events_breadcrumb
  def add_events_breadcrumb
    add_breadcrumb 'Events', admin_events_path  
  end

  before_filter :load_event, :only => [:edit, :update, :destroy]
  def load_event
    @event = Event.for_site(Site.current).find(params[:id])   
  end
  
  before_filter :load_season_options, :only => [:index, :new, :edit]
  def load_season_options
    @seasons = Season.for_site(Site.current).desc(:starts_on).entries
  end
  
  before_filter :load_division_options, :only => [:index, :new, :edit]
  def load_division_options
    @divisions = Division.for_site(Site.current).asc(:name).entries
  end

  before_filter :load_venue_options, :only => [:new, :edit]
  def load_venue_options
    @venues = Venue.for_site(Site.current).asc(:name).entries
  end

  before_filter :load_division, :only => [:index]
  def load_division
    @division = Division.for_site(Site.current).find(params[:division_id]) if params[:division_id]
  end
  
  before_filter :load_season, :only => [:index]
  def load_season
    @season = Season.for_site(Site.current).find(params[:season_id]) if params[:season_id]    
  end

  before_filter :load_events, :only => [:index]
  def load_events
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    @days_in_future = 14
    @days_in_past = 7
    @start_date = @date - @days_in_past - 1
    @end_date = @date + @days_in_future + 1
    @next_date = @date + @days_in_future + @days_in_past
    @prev_date = @date - @days_in_future - @days_in_past

    @events = Event.for_site(Site.current)    
    @events = @events.for_division(@division) if @division
    @events = @events.for_season(@season) if @season
    @events = @events.between(@start_date, @end_date) unless @division.present? || @season.present?
    @events = @events.asc(:starts_on)    
  end

  def index
  end

  def new
    @event = Event.new
    @event.season_id = params[:season_id]
    @event.venue_id = @venues[0].id if @venues.count
  end

  def edit
  end

  def create
    @event = Event.new(params[:event])
    @event.site = Site.current
    if @event.save
      return_to_last_point(:notice => 'Event was successfully created.')
    else
      load_season_options
      load_team_options
      load_venue_options
      load_division_options
      render :action => "new"
    end
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      return_to_last_point(:notice => 'Event was successfully updated.')
    else
      load_season_options
      load_team_options
      load_venue_options     
      load_division_options
      render :action => "edit"
    end
  end

  def destroy
    @event.destroy
    flash[:notice] = "Event has been deleted"
  end

end
