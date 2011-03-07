class League::HomeController < League::BaseLeagueController
  
  def index
    @divisions = Division.all.asc(:name).entries
    @seasons = Season.all.desc(:starts_on).entries
  end

end
