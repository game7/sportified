class Admin::BaseLeagueController < Admin::AdminController

  def set_breadcrumbs
    super
    add_breadcrumb( "League", admin_root_path )
  end
  
  def set_area_navigation
      add_area_menu_item "Leagues", admin_leagues_path
      add_area_menu_item "Seasons", admin_seasons_path
      add_area_menu_item "Venues", admin_venues_path
      add_area_menu_item "Clubs", admin_clubs_path
      add_area_menu_item "Teams", admin_teams_path
      add_area_menu_item "Schedule", admin_events_path

  end  

end
