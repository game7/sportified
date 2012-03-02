class Team::Record::Processor

  def self.recalculate(season = nil)
    
    teams = season.teams if season
    teams ||= Team.all
    
    # first clear them all
    teams.each do |team|
      team.record = Team::Record.new
      team.save
    end  

    # then repost the results
    games = season.events.where(:_type => 'game') if season
    games ||= Game.all

    games.asc(:starts_on).each do |game|
      post_game! game if game.has_result?
    end

    #then update power rankings
    #update_power_rankings(division_id, season_id)

  end

  #def update_power_rankings_from_game(game)
  #  left_division = game.left_team.division_id
  #  right_division = game.right_team.division_id
  #  update_power_rankings(left_division, game.season_id)
  #  update_power_rankings(right_division, game.season_id) if left_division != right_division    
  #end

  #def update_power_rankings(division_id, season_id)
  #  
  #  teams = Hash.new
  #
  #  # make hash of team records
  #  Team.for_division(division_id).for_season(season_id).each do |team|
  #    teams[team.id] = team
  #  end
  #
  #  # first update opponent's winning percentage
  #  teams.each do |id, team|
  #    record = team.record
  #    count = 0
  #    owp = 0.0
  #    record.results.each do |result|
  #      opponent = teams[result.opponent_id]
  #      if opponent
  #        count += 1
  #        owp += opponent.record.pct
  #      end
  #    end
  #    record.owp = count > 0 ? owp / count : 0.0   
  #  end
  #
  #  #then update opponent's opponent's win percentage, sos and rpi
  #  teams.each do |id, team|
  #    record = team.record
  #    count = 0
  #    oowp = 0.0
  #    record.results.each do |result|
  #      opponent = teams[result.opponent_id]
  #      if opponent
  #        count += 1
  #        oowp += opponent.record.owp
  #      end
  #    end
  #    record.oowp = count > 0 ? oowp / count : 0.0  
  #    record.sos = ( ( 2 * record.owp ) + record.oowp ) / 3
  #    record.rpi = ( record.pct * 0.25 ) + ( record.owp * 0.5 ) + ( record.oowp * 0.25 )
  #  end
  #
  #  # save each team's record
  #  teams.each{ |id, team| team.save }
  #     
  #end
  #
  def self.post_game!(game)
  
    away = game.away_team.record
    away.post_result_from_game(game)
    away.save
    home = game.home_team.record
    home.post_result_from_game(game)
    home.save
   
  end

  #on :game_unfinalized do |message|
  #  
  #  game = Game.find(message.data[:game_id])
  #  left = game.left_team.record
  #  left.cancel_result_for_game(game)
  #  left.save
  #  right = game.right_team.record
  #  right.cancel_result_for_game(game)
  #  right.save
  #  manager = TeamRecordManager.new
  #  manager.update_power_rankings_from_game(game)
  #
  #end

end
