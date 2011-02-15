module League::TeamsHelper
  
  def team_season_select(division)
    select( "season", :id, get_team_season_options(division), { :selected => request.fullpath }, { :class => "redirect_to" } )
  end

  def get_team_season_options(division)
    division.seasons.collect do |s| 
      [ s.name, get_team_season_url(division.slug, s.id == division.current_season_id ? nil : s.slug) ]
    end
  end

  def get_team_season_url(division_slug, season_slug)
    league_division_teams_friendly_path(division_slug, season_slug)
  end

end
