class League::Admin::LeaguesController < League::Admin::BaseLeagueController
  
  def show
    @divisions = Division.for_site(Site.current).asc(:name)  
    @seasons = Season.for_site(Site.current).desc(:starts_on)
  end

end
