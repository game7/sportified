class League::Admin::BaseLeagueController < Admin::AdminController

  def set_breadcrumbs
    super
    add_breadcrumb( "League", league_admin_root_path )
  end
  
  def set_area_navigation
      
      add_area_menu_item "Seasons", league_admin_seasons_path
      add_area_menu_item "Venues", league_admin_venues_path
      add_area_menu_item "Clubs", league_admin_clubs_path
      add_area_menu_item "Teams", league_admin_teams_path
      add_area_menu_item "Schedule", league_admin_events_path
      add_area_menu_item "Results", league_admin_game_results_path

  end  

end
