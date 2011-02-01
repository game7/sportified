class League::ScoreboardController < League::BaseSeasonController
  
  before_filter :load_for_season

  def load_for_season
    
    @division = Division.with_slug(params[:division_slug]).first
    @season = params[:season_slug] ? @division.seasons.with_slug(params[:season_slug]).first : @division.current_season
    @season ||= @division.seasons.order_by(:starts_on, :desc).last   

    add_new_breadcrumb @division.name, league_division_friendly_path(@division.slug)
    add_new_breadcrumb @season.name

    load_area_navigation @division, @season
 
  end

  def index
    @games = @season.games.in_the_past.desc(:starts_on).entries
  end

end
