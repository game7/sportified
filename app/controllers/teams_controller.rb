require 'icalendar'

class TeamsController < BaseLeagueController
  before_filter :set_team_breadcrumbs, :only => [:schedule, :show, :roster]

  def index
    add_breadcrumb "Teams"

    @teams = @league.teams.for_season(@season).asc(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end

  def schedule
    @events = Event.for_site(Site.current).for_team(@team).asc(:starts_on)
    add_breadcrumb "Schedule"
    @team_links = links_to_team_schedule(@division, @season)

    respond_to do |format|
      format.html
      format.ics { to_ical(@events) }
    end    

  end

  def roster
    add_breadcrumb "Roster"
    @players = @team.players.asc(:last_name)
    @team_links = links_to_team_roster(@division, @season)
  end

  def show
    @teams = @division.teams.for_season(@season).desc("record.pts")
    @current_game = Game.for_team(@team).in_the_future().desc(:starts_on).first
    @next_game = Game.for_team(@team).in_the_future().desc(:starts_on).skip(1).first
    @related_teams = Team.for_club(@team.club_id).asc(:season_name) if @team.club_id
    @players = @team.players.asc(:last_name)
  end
  
  private
  def set_team_breadcrumbs 
    add_breadcrumb "Teams", teams_path(@division.slug) 
    add_breadcrumb @team.name if @team
  end

  def load_objects
    super
    @team = @division.teams.for_season(@season).with_slug(params[:team_slug]).first unless action_name == "index"
  end

  def links_to_team_schedule(division, season)
    teams = division.teams.for_season(season).asc(:name)
    teams.each.collect do |t|
      [t.name, team_schedule_path(division.slug, season.slug, t.slug)] 
    end   
  end

  def links_to_team_roster(division, season)
    teams = division.teams.for_season(season).asc(:name)
    teams.each.collect do |t|
      [t.name, team_roster_path(division.slug, season.slug, t.slug)] 
    end   
  end

  def links_to_season
    seasons = Season.desc(:starts_on)
    current = find_current_season
    links = seasons.each.collect{ |s| [s.name + " Season", teams_path(:season_slug => s == current ? nil : s.slug, :division_slug => params[:division_slug])] }
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