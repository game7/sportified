class Admin::LeaguesController < Admin::BaseLeagueController
  
  def show
    @divisions = Division.all.asc(:name)  
    @seasons = Season.all.desc(:starts_on)
  end

end
