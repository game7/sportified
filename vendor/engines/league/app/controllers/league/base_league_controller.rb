class League::BaseLeagueController < ApplicationController

  def set_breadcrumbs
    super
    add_breadcrumb("League", league_path)
  end  

  def set_area_navigation
    super
    add_area_ancestor("League", league_path)
  end

end
