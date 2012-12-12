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
    @teams = @league.teams.for_season(@season).asc('division_name').asc('pool').asc('seed').desc('record.pts').desc('record.w').desc('record.margin')
  end
  
  private
  
  def get_season_options
    @season_options = @league.seasons.all.desc(:starts_on).collect{|s| [s.name, standings_path(:league_slug => @league.slug, :season_slug => s == @season ? nil : s.slug)]}
  end  
  
end
