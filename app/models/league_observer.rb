class LeagueObserver < Mongoid::Observer
  
  def after_save(league)
    league.teams.each do |team|
      team.set_league_name_and_slug league
      team.save
    end
  end
  
end
