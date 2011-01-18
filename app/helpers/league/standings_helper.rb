module League::StandingsHelper
  
  def link_to_standings(division, season)
    if division.current_season_id == season.id
      @path = league_standings_path(@division.slug)
    else
      @path = league_standings_path(@division.slug, season.slug)
    end
    link_to season.name, @path
  end

end
