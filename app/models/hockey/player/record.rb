module Hockey
  class Player::Record
    include Mongoid::Document
    include Stats
    
    embedded_in :player
    embeds_many :results, :class_name => "Hockey::Player::Result"
    
    def post_result result
      cancel_result(result) if has_result? result
      results << result
      add_stats result
    end

    def cancel_result result
      result.delete
      subtract_stats result
    end

    def has_result? result 
      results.where(:game_id => result.game_id).count > 0
    end  
    
    
  end
end