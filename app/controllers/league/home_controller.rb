class League::HomeController < League::BaseLeagueController
  
  def index
    @divisions = Division.asc(:name)
  end

end
