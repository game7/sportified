module League::TeamsHelper
  
  def season_select(division)
    select( "season", :id, get_season_options(division), { :selected => request.request_uri }, { :class => "redirect_to" } )
  end

  def get_season_options(division)
    division.seasons.collect do |s| 
      [ s.name, get_season_url(division.slug, s.id == division.current_season_id ? nil : s.slug) ]
    end
  end

  def get_season_url(division_slug, season_slug)
    league_season_teams_friendly_path(division_slug, season_slug)
  end

end
