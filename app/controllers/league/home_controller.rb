class League::HomeController < League::LeagueController
  
  def index
    @divisions = Division.asc(:name)
  end

end
