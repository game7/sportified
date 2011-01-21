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

  end

  def post_result_to_team_records!(game)
  
    @left = game.left_team.team.record
    @left.post_result_from_game(game)
    @left.save
    
    @right = game.right_team.team.record
    @right.post_result_from_game(game)
    @right.save
   
  end

  def create_record_for_team!(team)

    @record = TeamRecord.new
    @record.season_id = team.season_id
    @record.team_id = team.id
    @record.team_name = team.name
    @record.save
    
  end

  on :team_created do |event|
    
    @team = Team.find(event.data[:team_id])
    @manager = TeamRecordManager.new
    @manager.create_record_for_team! @team
    
  end
  
  on :game_result_posted do |event|
    
    @game = Game.find(event.data[:game_id])
    @manager = TeamRecordManager.new
    @manager.post_result_to_team_records!(@game)

  end

  on :game_result_deleted do |event|
    
    @game = Game.find(event.data[:game_id])
    
    @left = @game.left_team.team.record
    @left.cancel_result_for_game(@game)
    @left.save
    
    @right = @game.right_team.team.record
    @right.cancel_result_for_game(@game)
    @right.save

  end

end
