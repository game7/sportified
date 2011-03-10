class League::StandingsController < League::BaseDivisionSeasonController

  def set_breadcrumbs
    super
    add_new_breadcrumb "Standings" 
  end
  
  def index
    @columns = @division.standings_columns.asc(:order)
    @team_records = @division.team_records.for_season(@season).desc(:pts).entries
    if @columns.count == 0 then flash[:error] = "Standings layout has not been setup for this season" end
  end


end
