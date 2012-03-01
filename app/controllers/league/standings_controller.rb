class League::StandingsController < League::BaseDivisionSeasonController

  def set_breadcrumbs
    super
    add_breadcrumb "Standings" 
  end
  
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
    @season = Season.find(params[:season_id]) if params[:season_id]   
    @season ||= Season.most_recent()    
  end


end
