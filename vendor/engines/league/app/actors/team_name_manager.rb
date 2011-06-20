class TeamNameManager
  extend EventHandler

  on :division_renamed do |message|
    Team.for_division(message.data[:division_id]).each do |team|
      team.division_name = message.data[:division_name]
      team.division_slug = message.data[:division_slug]
      team.save
    end
  end

  on :season_renamed do |message|
    Team.for_season(message.data[:season_id]).each do |team|
      team.season_name = message.data[:season_name]
      team.season_slug = message.data[:season_slug]
      team.save
    end    
  end

end
