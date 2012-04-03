class StandingsController < BaseLeagueController
  before_filter :get_season_options
  
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
    @teams = @league.teams.for_season(@season).desc('record.pts')
  end
  
  private
    
    def get_season_options
      @season_options = Season.all.desc(:starts_on).collect{|s| [s.name, standings_path(:season_slug => s.slug)]}
    end
  
end
