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
      return if game.result.final?
      game.home_team_score = statsheet.goals.home.count
      game.away_team_score = statsheet.goals.away.count
      game.save
    end
    
    def self.update_player_stats statsheet
      statsheet.calculate_player_stats
      statsheet.save
    end
    
    def self.post_player_results statsheet
      statsheet.players.each do |p|
        #player = Player.where(id:  p.player_id).first
        player = p.player
        puts 'NO PLAYER' if player.nil?
        next if player.nil?
        result = p.to_result
        player.record.post_result result
        player.save
      end
    end
    
    def self.unpost_player_results statsheet
      statsheet.players.each do |p|
        #player = Player.where(id:  p.player_id).first
        player = p.player
        puts 'NO PLAYER' if player.nil?
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