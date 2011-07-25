require 'icalendar'

class League::TeamsController < League::BaseDivisionSeasonController
  
  before_filter :set_team_breadcrumbs, :only => [:schedule, :show, :roster]
  def set_team_breadcrumbs 
    add_breadcrumb "Teams", league_teams_path(@division.slug) 
    add_breadcrumb @team.name if @team
  end

  def load_objects
    super
    @team = @division.teams.for_season(@season).with_slug(params[:team_slug]).first unless action_name == "index"
  end

  def links_to_team_schedule(division, season)
    teams = division.teams.for_season(season).asc(:name)
    teams.each.collect do |t|
      [t.name, league_team_schedule_path(division.slug, season.slug, t.slug)] 
    end   
  end

  def links_to_team_roster(division, season)
    teams = division.teams.for_season(season).asc(:name)
    teams.each.collect do |t|
      [t.name, league_team_roster_path(division.slug, season.slug, t.slug)] 
    end   
  end

  def links_to_season
    seasons = Season.for_site(Site.current).desc(:starts_on)
    current = find_current_season
    links = seasons.each.collect{ |s| [s.name + " Season", league_teams_path(:season_slug => s == current ? nil : s.slug, :division_slug => params[:division_slug])] }
  end

  def links_to_division
    links = Division.for_site(Site.current).asc(:name).each.collect{ |d| [d.name + " Division", league_teams_path(:division_slug => d.slug, :season_slug => params[:season_slug])] }
    links.insert(0, ['All Divisions', league_teams_path])
  end

  def index
    add_breadcrumb "Teams"

    @division_options = links_to_division
    @season_options = links_to_season

    @teams = Team.for_season(@season)
    @teams = @teams.for_division(@division) if @division
    @teams = @teams.asc(:division_name).asc(:name).entries

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end

  def schedule
    @games = Game.for_site(Site.current).for_team(@team).asc(:starts_on)
    add_breadcrumb "Schedule"
    @team_links = links_to_team_schedule(@division, @season)

    respond_to do |format|
      format.html
      format.ics { to_ical(@games) }
    end    

  end

  def to_ical(games)
    calendar = Icalendar::Calendar.new
    games.each do |game|
      event = Icalendar::Event.new
      event.uid = game.id.to_s
      event.start = game.starts_on
      event.end = game.ends_on
      event.summary = "#{game.left_team_name} vs. #{game.right_team_name}"
      event.location = game.venue_name
      calendar.add event
    end
    calendar.publish
    headers["Content-Type"] = "text/calendar; charset=UTF-8"
    render :text => calendar.to_ical, :layout => false
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

end
