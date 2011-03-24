class League::HomeController < League::BaseLeagueController
  
  def index
    @divisions = Division.for_site(Site.current).asc(:name).entries
    @seasons = Season.for_site(Site.current).desc(:starts_on).entries
  end

end
