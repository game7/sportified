class SeasonObserver < Mongoid::Observer
  
  def after_save(season)
    season.teams.each do |team|
      team.set_season_name_and_slug season
      team.save
    end
  end
    
end
