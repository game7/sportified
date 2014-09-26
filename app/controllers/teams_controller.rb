require 'icalendar'

class TeamsController < BaseLeagueController
  before_filter :verify_admin, :except => [:show, :index, :schedule, :roster, :statistics]
  before_filter :set_team_breadcrumbs, :only => [:schedule, :show, :roster]
  before_filter :get_season_options, :only => [:index]
  before_filter :find_team, :only => [:edit, :update, :destroy]
  before_filter :load_league_options, :only => [:new]
  before_filter :load_division_options, :only => [:new, :edit]
  before_filter :load_club_options, :only => [:new, :edit]
  
  def index
    add_breadcrumb "Teams"

    @teams = @league.teams.for_season(@season).asc(:name).without(:record, :event_ids)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end

  def schedule
    @team = @league.teams.for_season(@season).with_slug(params[:team_slug]).first
    @events = Event.for_team(@team).asc(:starts_on)
    add_breadcrumb "Schedule"
    @team_links = links_to_team_schedule(@league, @season)

    respond_to do |format|
      format.html
      format.ics { to_ical(@events) }
    end    

  end
  
  def edit

  end
  
  def update
    @league = @team.league
    @team.update_attributes(params[:team])    
  end

  def roster
    add_breadcrumb "Roster"
    @team = @league.teams.for_season(@season).with_slug(params[:team_slug]).first    
    @players = @team.players.asc(:last_name)
    @team_links = links_to_team_roster(@league, @season)
  end
  
  def statistics
    @team = @league.teams.for_season(@season).with_slug(params[:team_slug]).first   
    add_breadcrumb "Statistics"
    @players = @team.players.desc(:"record.pts")
    @goalies = @team.players.where(:"record.g_gp".gt => 0).desc(:"record.g_svp")
  end

  def show
    @teams = @division.teams.for_season(@season).desc("record.pts")
    @current_game = Game.for_team(@team).in_the_future().desc(:starts_on).first
    @next_game = Game.for_team(@team).in_the_future().desc(:starts_on).skip(1).first
    @related_teams = Team.for_club(@team.club_id).asc(:season_name) if @team.club_id
    @players = @team.players.asc(:last_name)
  end
  
  private
  
  def find_team
    @team = Team.find(params[:id])
  end
  
  def load_league_options
    @leagues = @season.leagues.asc(:name)
  end
  
  def load_division_options
    league_id = @team ? @team.league_id : params[:league_id]
    season_id = @team ? @team.season_id : params[:season_id]
    @divisions = Division.for_league(league_id).for_season(season_id).asc(:name)
  end

  def load_club_options
    @clubs = Club.asc(:name).entries
  end  
  
  def set_area_navigation
    puts params[:action]
    super unless [:edit,:update,:new,:create].include? params[:action].to_sym
  end
  
  def set_team_breadcrumbs 
    add_breadcrumb "Teams", teams_path(@league.slug) 
    add_breadcrumb @team.name if @team
  end

  def load_objects
    super
    
  end
  
  def get_season_options
    @season_options = @league.seasons.all.desc(:starts_on).collect{|s| [s.name, teams_path(:league_slug => @league.slug, :season_slug => s.slug)]}
  end  

  def links_to_team_schedule(league, season)
    teams = @league.teams.for_season(season).asc(:name)
    teams.each.collect do |t|
      [t.name, team_schedule_path(league.slug, season.slug, t.slug)] 
    end   
  end

  def links_to_team_roster(league, season)
    teams = @league.teams.for_season(season).asc(:name)
    teams.each.collect do |t|
      [t.name, team_roster_path(league.slug, season.slug, t.slug)] 
    end
  end
  
  def to_ical(events)
    cal = Icalendar::Calendar.new
    events.each do |e|
      event = Icalendar::Event.new
      event.uid = e.id.to_s
      event.start = e.starts_on
      event.end = e.ends_on
      event.summary = e.summary
      event.location = e.venue_name
      cal.add event
    end
    cal.publish
    send_data(cal.to_ical, :type => 'text/calendar', :disposition => "inline; filename=#{@team.slug}-#{@team.season_slug}-schedule.ics", :filename => "#{@team.slug}-#{@team.season_slug}-schedule.ics")
  end  

end
