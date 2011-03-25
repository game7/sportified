class Admin::BaseLeagueController < Admin::AdminController

  def set_breadcrumbs
    super
    add_breadcrumb( "League", admin_league_path )
  end

end
