class League::StandingsController < League::BaseDivisionController
  
  before_filter :load_for_division

  def load_for_division
    
    @division = Division.with_slug(params[:division_slug]).first
    @season = params[:season_slug] ? @division.seasons.with_slug(params[:season_slug]).first : @division.default_season
    add_new_breadcrumb @division.name, league_division_friendly_path(@division.slug)
    add_new_breadcrumb @season.name if @season
    load_area_navigation @division

  end
  
  def index
    @columns = @division.standings_columns.asc(:order)
    @team_records = @division.team_records.for_season(@season).desc('points').entries
    if @columns.count == 0 then flash[:error] = "Standings layout has not been setup for this season" end
  end


end
