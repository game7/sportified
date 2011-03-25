class League::StandingsController < League::BaseDivisionSeasonController

  def set_breadcrumbs
    super
    add_breadcrumb "Standings" 
  end
  
  def index
    layout = @division.standings_layout
    if layout
      @columns = @division.standings_layout.columns.asc(:order)
      @team_records = @division.team_records.for_season(@season).desc(:pts).entries
    else 
      @columns = []
      @team_records = []
      flash[:error] = "Standings layout has not been setup for this division"
    end
  end


end
