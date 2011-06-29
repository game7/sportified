class League::BaseLeagueController < ApplicationController

  def set_breadcrumbs
    super
    add_breadcrumb("League", league_path)
  end  

  def set_area_navigation
    super
    add_area_menu_item('Home', league_path)
    add_area_menu_item('Schedule', league_schedule_path)
    add_area_menu_item('Scoreboard', league_scoreboard_path)
    #add_area_descendant('Standings', league_standings_path)
    # TODO: add_area_menu_item('Statistics')
    add_area_menu_item('Teams', league_teams_path)      
  end

end
