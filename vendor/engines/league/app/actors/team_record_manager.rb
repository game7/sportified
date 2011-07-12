class TeamRecordManager
  extend MessageHandler

  def recalculate(division_id, season_id)
    
    # first clear them all
    Team.for_division(division_id).for_season(season_id).each do |team|
      team.record = TeamRecord.new
      team.save
    end   

    # then repost the results
    Game.for_division(division_id).for_season(season_id).each do |game|
      post_result_to_team_records!(game) if game.final?
    end

    #then update power rankings
    update_power_rankings(division_id, season_id)

  end

  def update_power_rankings_from_game(game)
    left_division = game.left_team.division_id
    right_division = game.right_team.division_id
    update_power_rankings(left_division, game.season_id)
    update_power_rankings(right_division, game.season_id) if left_division != right_division    
  end

  def update_power_rankings(division_id, season_id)
    
    teams = Hash.new

    # make hash of team records
    Team.for_division(division_id).for_season(season_id).each do |team|
      teams[team.id] = team
    end

    # first update opponent's winning percentage
    teams.each do |id, team|
      record = team.record
      count = 0
      owp = 0.0
      record.results.each do |result|
        opponent = teams[result.opponent_id]
        if opponent
          count += 1
          owp += opponent.record.pct
        end
      end
      record.owp = count > 0 ? owp / count : 0.0   
    end

    #then update opponent's opponent's win percentage, sos and rpi
    teams.each do |id, team|
      record = team.record
      count = 0
      oowp = 0.0
      record.results.each do |result|
        opponent = teams[result.opponent_id]
        if opponent
          count += 1
          oowp += opponent.record.owp
        end
      end
      record.oowp = count > 0 ? oowp / count : 0.0  
      record.sos = ( ( 2 * record.owp ) + record.oowp ) / 3
      record.rpi = ( record.pct * 0.25 ) + ( record.owp * 0.5 ) + ( record.oowp * 0.25 )
    end

    # save each team's record
    teams.each{ |id, team| team.save }
       
  end

  def post_result_to_team_records!(game)
  
    left = game.left_team.record
    left.post_result_from_game(game)
    left.save
    right = game.right_team.record
    right.post_result_from_game(game)
    right.save
   
  end

  
  on :game_finalized do |message|
    
    game = Game.find(message.data[:game_id])
    manager = TeamRecordManager.new
    manager.post_result_to_team_records!(game)
    manager.update_power_rankings_from_game(game)

  end

  on :game_unfinalized do |message|
    
    game = Game.find(message.data[:game_id])
    left = game.left_team.record
    left.cancel_result_for_game(game)
    left.save
    right = game.right_team.record
    right.cancel_result_for_game(game)
    right.save
    manager = TeamRecordManager.new
    manager.update_power_rankings_from_game(game)

  end

end
