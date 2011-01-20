class League::ScheduleController < League::LeagueController

  def index
    @division = Division.with_slug(params[:division_slug]).first
    @season = params[:season_slug] ? @division.seasons.with_slug(params[:season_slug]).first : @division.current_season
    @season ||= @division.seasons.order_by(:starts_on, :desc).last
    @games = @season.games
  end

end
