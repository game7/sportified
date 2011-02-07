class League::BaseSeasonController < League::BaseLeagueController
  

  def load_area_navigation(division, season)
    
    division ||= season.division

    add_area_menu_item('Home', league_season_friendly_path(division.slug, season.slug))
    add_area_menu_item('Schedule', league_division_schedule_friendly_path(division.slug))
    add_area_menu_item('Scoreboard', league_season_scoreboard_friendly_path(division.slug, season.slug))
    add_area_menu_item('Standings', league_season_standings_friendly_path(division.slug, season.slug))
    add_area_menu_item('Statistics')
    add_area_menu_item('Teams', league_season_teams_friendly_path(division.slug, season.slug))
    add_area_menu_item('Players')

  end

end

