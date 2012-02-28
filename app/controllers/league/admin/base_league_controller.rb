class League::Admin::BaseLeagueController < Admin::AdminController

  def set_breadcrumbs
    super
    add_breadcrumb( "League", league_admin_league_path )
  end

end
