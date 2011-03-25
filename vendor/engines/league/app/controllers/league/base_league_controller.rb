class League::BaseLeagueController < ApplicationController

  def set_breadcrumbs
    super
    add_breadcrumb("League", league_path)
  end  

end
