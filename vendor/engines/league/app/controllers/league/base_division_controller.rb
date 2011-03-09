class League::BaseDivisionController < League::BaseLeagueController
  

  def load_area_navigation(division)
    
    add_area_menu_item('Home', league_division_path(division.slug))
    add_area_menu_item('Schedule', league_schedule_path(division.slug))
    add_area_menu_item('Scoreboard', league_scoreboard_path(division.slug))
    add_area_menu_item('Standings', league_standings_path(division.slug))
    # TODO: add_area_menu_item('Statistics')
    add_area_menu_item('Teams', league_teams_path(division.slug))
    # TODO: add_area_menu_item('Players')

  end

end
