class League::HomeController < League::BaseLeagueController
  
  def index
    @divisions = Division.all.asc(:name)
  end

end
