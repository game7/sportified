module League::StandingsHelper
  
  def link_to_standings(division, season)
    if division.current_season_id == season.id
      @path = league_season_standings_friendly_path(@division.slug)
    else
      @path = league_season_standings_friendly_path(@division.slug, season.slug)
    end
    link_to season.name, @path
  end

  def is_float?(field)
    field && field.options[:type].to_s == "Float"
  end

end
