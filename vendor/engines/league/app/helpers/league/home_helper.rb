module League::HomeHelper
  
  def link_to_current_season(division)
    @season = division.current_season
    link_to @season.name, league_season_friendly_path( division.slug, @season.slug ) unless @season.nil?
  end
end
