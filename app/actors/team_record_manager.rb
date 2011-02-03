class TeamRecordManager
  extend EventHandler

  def recalculate_team_records(season_id)
    
    # first clear them all
    TeamRecord.where(:season_id => season_id).each do |record|
      record.reset!
      record.save
    end   

    # then repost the results
    Game.where(:season_id => season_id).each do |game|
      post_result_to_team_records!(game) if game.has_result?
    end

    #then update power rankings
    update_power_rankings(season_id)

  end

  def update_power_rankings(season_id)
    
    records = Hash.new

    # make hash of team records
    TeamRecord.where(:season_id=> season_id).each do |record|
      records[record.team_id] = record
    end

    # first update opponent's winning percentage
    records.each do |team_id, record|
      count = 0
      owp = 0.0
      record.results.each do |result|
        opponent = records[result.opponent_id]
        if opponent
          count += 1
          owp += opponent.win_percentage
        end
      end
      record.owp = count > 0 ? owp / count : 0.0   
    end

    #then update opponent's opponent's win percentage, sos and rpi
    records.each do |team_id, record|
      count = 0
      oowp = 0.0
      record.results.each do |result|
        opponent = records[result.opponent_id]
        if opponent
          count += 1
          oowp += opponent.owp
        end
      end
      record.oowp = count > 0 ? oowp / count : 0.0  
      record.sos = ( ( 2 * record.owp ) + record.oowp ) / 3
      record.rpi = ( record.win_percentage * 0.25 ) + ( record.owp * 0.5 ) + ( record.oowp * 0.25 )
    end

    # save each team's record
    records.each{ |team_id, record| record.save }
       
  end

  def post_result_to_team_records!(game)
  
    left = game.left_team.team.record
    left.post_result_from_game(game)
    left.save
    right = game.right_team.team.record
    right.post_result_from_game(game)
    right.save
   
  end

  def create_record_for_team!(team)

    record = TeamRecord.new
    record.season_id = team.season_id
    record.team_id = team.id
    record.team_name = team.name
    record.save
    
  end

  on :team_created do |event|
    
    team = Team.find(event.data[:team_id])
    manager = TeamRecordManager.new
    manager.create_record_for_team! team
    
  end
  
  on :game_result_posted do |event|
    
    game = Game.find(event.data[:game_id])
    manager = TeamRecordManager.new
    manager.post_result_to_team_records!(game)
    manager.update_power_rankings(game.season_id)

  end

  on :game_result_deleted do |event|
    
    game = Game.find(event.data[:game_id])
    left = game.left_team.team.record
    left.cancel_result_for_game(game)
    left.save
    right = game.right_team.team.record
    right.cancel_result_for_game(game)
    right.save
    manager = TeamRecordManager.new
    manager.update_power_rankings(game.season_id)

  end

end
