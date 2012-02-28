module League::StandingsHelper
  
  def link_to_standings(division)
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

  def standings_season_select(division)
    select( "season", :id, get_standings_season_options(division), { :selected => request.fullpath }, { :class => "redirect_to" } )
  end

  def get_standings_season_options(division)
    division.seasons.collect do |s| 
      [ s.name, get_standings_season_url(division.slug, s.id == division.current_season_id ? nil : s.slug) ]
    end
  end

  def get_standings_season_url(division_slug, season_slug)
    league_standings_path(division_slug, season_slug)
  end

end
