class Team::Record::Processor

  def self.recalculate(season = nil)
    
    puts "Recalculate Team Records for #{season.name}" if season
    puts "Recalculate Records for All Teams" unless season
    
    teams = season.teams if season
    teams ||= Team.all
    
    # first clear them all
    teams.each do |team|
      puts ""
      puts "Clearing Record for #{team.name}"
      team.record = Team::Record.new
      team.save
      puts "-- saved"
    end  

    # then repost the results
    games = Game.for_season(season).asc(:starts_on) if season
    games ||= Game.all.asc(:starts_on)
    
    puts ""
    puts "#{games.count} games to be processed"

    games.asc(:starts_on).each do |game|
      puts ""
      puts "Ready to process game: #{game.summary}"
      post_game! game if game.has_result?
      puts "-- posted"
    end
    
    puts ""
    puts "ALL DONE"

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
    update_team_record!(game.away_team, game) if game.away_team
    update_team_record!(game.home_team, game) if game.home_team
  end
  
  def self.update_team_record!(team, game)
    team.record.post_result_from_game(game)
    team.record.save
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
