module Hockey
  class Statsheet::Processor

    def self.post statsheet
      check_and_set_game_result statsheet
      update_player_stats statsheet
      post_player_results statsheet
      set_to_posted statsheet
    end

    def self.unpost statsheet
      unpost_player_results statsheet
      set_to_unposted statsheet
    end
    
    private
    
    def self.check_and_set_game_result statsheet
      game = statsheet.game
      return if game.has_result?
      result = game.build_result
      result.home_score = statsheet.home_goals_total
      result.away_score = statsheet.away_goals_total
      result.completed_in = statsheet.completed_in
      game.save
    end
    
    def self.update_player_stats statsheet
      statsheet.calculate_player_stats
      statsheet.save
    end
    
    def self.post_player_results statsheet
      statsheet.players.each do |p|
        player = p.player
        next if player.nil?
        result = p.to_result
        player.record.post_result result
        player.save
      end
    end
    
    def self.unpost_player_results statsheet
      statsheet.players.each do |p|
        player = p.player
        next if player.nil?
        player.record.cancel_result_for_game statsheet.game_id
        player.save
      end
    end    
    
    def self.set_to_posted statsheet
      statsheet.is_posted = true
      statsheet.save
    end
    
    def self.set_to_unposted statsheet
      statsheet.is_posted = false
      statsheet.save
    end
    
  end
end