class League::TeamsController < League::BaseDivisionController
  
  before_filter :load_division
  before_filter :load_season
  before_filter :load_team, :only => [:show, :schedule]
  before_filter :set_breadcrumbs
  before_filter :set_navigation
  
  def load_division
    @division = Division.with_slug(params[:division_slug]).first    
  end

  def load_season
    @season = params[:season_slug] ? Season.with_slug(params[:season_slug]).first : @division.current_season
  end

  def load_team
    @team = Division.teams.for_season(@season).with_slug(params[:team_slug]).first
  end

  def set_breadcrumbs
    add_new_breadcrumb @division.name, league_division_path(@division.slug)
    add_new_breadcrumb @season.name
    add_new_breadcrumb @team.name if @team  
  end

  def set_navigation
    load_area_navigation @division    
  end


  def links_to_team_schedule(division, season)
    teams = division.teams.for_season(season).asc(:name)
    teams.each.collect do |t|
      [t.name, league_team_schedule_friendly_path(division.slug, season.slug, t.slug)] 
    end   
  end

  def index
    @teams = @season.teams.asc(:name).entries

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end

  def schedule
    @games = Game.for_team(@team).asc(:starts_on)
    @team_links = links_to_team_schedule(@division, @season)
  end

  def show

  end

end
