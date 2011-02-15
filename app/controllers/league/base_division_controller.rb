class League::BaseDivisionController < League::BaseLeagueController
  

  def load_area_navigation(division)
    
    add_area_menu_item('Home', league_division_friendly_path(division.slug))
    add_area_menu_item('Schedule', league_division_schedule_friendly_path(division.slug))
    add_area_menu_item('Scoreboard', league_division_scoreboard_friendly_path(division.slug))
    add_area_menu_item('Standings', league_division_standings_friendly_path(division.slug))
    #add_area_menu_item('Statistics')
    add_area_menu_item('Teams', league_division_teams_friendly_path(division.slug))
    #add_area_menu_item('Players')

  end

end
