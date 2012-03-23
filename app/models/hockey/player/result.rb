module Hockey
  class Player::Result
    include Mongoid::Document
    include Stats
    
    embedded_in :player
  
    field :played_on, :type => Date
    field :opponent_name
    field :decision
    field :completed_in
    field :scored, :type => Integer
    field :allowed, :type => Integer

    belongs_to :game
    belongs_to :opponent, :class_name => 'Team'  
    
    def load(game, player) 

      self.game_id = game.id    
      self.played_on = game.starts_on.to_date
      self.completed_in = game.result.completed_in

      if player.side == 'away'
        self.opponent_id = game.home_team_id
        self.opponent_name = game.home_team_name
        self.scored = game.result.away_score
        self.allowed = game.result.home_score
      else
        self.opponent_id = game.away_team_id
        self.opponent_name = game.away_team_name
        self.scored = game.result.home_score
        self.allowed = game.result.away_score
      end
      self.update_decision
      
      self.add_stats player
    end
    
    def update_decision

      margin = scored - allowed

      case
        when margin > 0 then self.decision = 'win'
        when margin == 0 then self.decision = 'tie'
        when margin < 0 then self.decision = 'loss'
      end

    end
    
  end
end