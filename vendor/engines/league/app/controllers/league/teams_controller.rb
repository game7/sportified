class League::TeamsController < League::BaseDivisionSeasonController
  
  before_filter :load_team, :only => [:show, :schedule]
  before_filter :set_team_breadcrumbs, :only => [:schedule, :show]

  def set_team_breadcrumbs 
    add_new_breadcrumb @team.name if @team
  end

  def load_team
    @team = @division.teams.for_season(@season).with_slug(params[:team_slug]).first
  end

  def links_to_team_schedule(division, season)
    teams = division.teams.for_season(season).asc(:name)
    teams.each.collect do |t|
      [t.name, league_team_schedule_friendly_path(division.slug, season.slug, t.slug)] 
    end   
  end

  def index
    add_new_breadcrumb "Teams"
    @teams = @division.teams.for_season(@season).asc(:name).entries

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end

  def schedule
    add_new_breadcrumb "Schedule"
    @games = Game.for_team(@team).asc(:starts_on)
    @team_links = links_to_team_schedule(@division, @season)
  end

  def show

  end

end
