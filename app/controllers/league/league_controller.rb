class League::LeagueController < ApplicationController

  before_filter :set_area_info

  def set_area_info
    @area_name = "League"  
    @area_url = league_path
  end

end
