class League::StandingsController < League::BaseDivisionController
  
  before_filter :load_division
  before_filter :load_season
  before_filter :set_breadcrumbs
  before_filter :set_navigation

  def load_division   
    @division = Division.with_slug(params[:division_slug]).first
  end

  def load_season
    @season = params[:season_slug] ? @division.seasons.with_slug(params[:season_slug]).first : @division.default_season    
  end

  def set_breadcrumbs
    add_new_breadcrumb @division.name, league_division_path(@division.slug)
    add_new_breadcrumb @season.name if @season 
    add_new_breadcrumb "Standings"   
  end

  def set_navigation
    load_area_navigation @division    
  end
  
  def index
    @columns = @division.standings_columns.asc(:order)
    @team_records = @division.team_records.for_season(@season).desc(:pts).entries
    if @columns.count == 0 then flash[:error] = "Standings layout has not been setup for this season" end
  end


end
