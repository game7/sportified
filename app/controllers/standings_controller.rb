class StandingsController < BaseLeagueController
  before_filter :get_season_options

  def index
    @teams = @division.teams.for_season(@season)
  end

  private

  def get_season_options
    most_recent = League::Season.most_recent
    @season_options = @division.seasons.all.order('starts_on DESC').collect{|s| [s.name, league_standings_path(@program.slug, @division.slug, s == most_recent ? nil : s.slug)]}
  end

end
