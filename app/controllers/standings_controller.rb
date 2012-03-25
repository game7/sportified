class StandingsController < BaseLeagueController
  
  def index
    #layout = @division.standings_layout
    #if layout
    #  @columns = @division.standings_layout.columns.asc(:order)
    #  @teams = @division.teams.for_season(@season).desc('record.pts').entries
    #else 
    #  @columns = []
    #  @teams = []
    #  flash[:error] = "Standings layout has not been setup for this division"
    #end
    add_breadcrumb "Standings"
    add_breadcrumb @season.name if @season
    @teams = @league.teams.for_season(@season).desc('record.pts')
  end
  
end
