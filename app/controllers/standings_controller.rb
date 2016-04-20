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
    @teams = @division.teams.for_season(@season).order('pool, seed, ' + @division.standings_schema['order'])
  end

  private

  def get_season_options
    most_recent = League::Season.most_recent
    @season_options = @division.seasons.all.order('starts_on DESC').collect{|s| [s.name, standings_path(:division_slug => @division.slug, :season_slug => s == most_recent ? nil : s.slug)]}
  end

end
