class TeamGameResult
  include Mongoid::Document

  COMPLETED_IN = %w[regulation overtime shootout forfeit]  
  DECISION = %w[win loss tie]

  field :played_on, :type => Date
  field :opponent_name
  field :decision
  field :completed_in
  field :scored, :type => Integer
  field :allowed, :type => Integer

  embedded_in :team_record, :inverse_of => :results
  referenced_in :game
  referenced_in :opponent, :class_name => 'Team'

  def initialize(params = nil)
    super(nil)
    if (params && params[:game] && params[:team_id])
      self.load_from_game(params[:team_id], params[:game]) if params[:game] && params[:team_id]
    end
  end

  def load_from_game(team_id, game)
    
    result = game.result

    self.game_id = game.id    
    self.played_on = game.starts_on.to_date
    self.completed_in = result.completed_in

    if game.left_team_id == team_id
      self.opponent_id = game.right_team_id
      self.opponent_name = game.right_team_name
      self.scored = result.left_team_score
      self.allowed = result.right_team_score
    elsif game.right_team_id == team_id
      self.opponent_id = game.left_team_id
      self.opponent_name = game.left_team_name
      self.scored = result.right_team_score
      self.allowed = result.left_team_score
    end

    self.update_decision

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
