class Admin::BaseLeagueController < Admin::AdminController

  def set_breadcrumbs
    super
    add_breadcrumb( "League", admin_root_path )
  end

  def set_area_navigation

  end

end
