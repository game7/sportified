class TeamRecordManager
  extend EventHandler
  
  on :game_result_posted do |event|
    
    @game = Game.find(event.data[:game_id])
    
    @left_team = @game.left_team.team
    @left_team.record.post_result_from_game(@game)
    @left_team.save
    
    @right_team = @game.right_team.team
    @right_team.record.post_result_from_game(@game)
    @right_team.save

  end

end
