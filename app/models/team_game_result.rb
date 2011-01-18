class TeamGameResult
  include Mongoid::Document

  COMPLETED_IN = %w[regulation overtime shootout forfeit]  
  DECISION = %w[win loss tie]

  field :played_on, :type => Date
  field :opponent_name
  field :decision
  field :completed_in
  field :goals_scored, :type => Integer
  field :goals_allowed, :type => Integer

  embedded_in :team_record, :inverse_of => :results
  referenced_in :game
  referenced_in :opponent, :class_name => 'Team'

  def initialize(params = nil)
    super(nil)
    self.load_from_game(params[:team], params[:game]) if params[:game] && params[:team]
  end

  def load_from_game(team, game)
    
    @result = game.result

    self.game_id = game.id    
    self.played_on = @result.played_on
    self.completed_in = @result.completed_in

    if game.left_team.team_id = team.id
      self.opponent_id = game.right_team.team_id
      self.opponent_name = game.right_team.name
      self.goals_scored = @result.left_team_score
      self.goals_allowed = @result.right_team_score
    elsif game.right_team.team_id = team.id
      self.opponent_id = game.left_team.team_id
      self.opponent_name = game.left_team.name
      self.goals_scored = @result.right_team_score
      self.goals_allowed = @result.left_team_score
    end

    self.update_decision

  end

  def update_decision
    
    @margin = goals_scored - goals_allowed
    
    case
      when @margin > 0 then self.decision = 'win'
      when @margin == 0 then self.decision = 'tie'
      when @margin < 0 then self.decision = 'loss'
    end

  end

end
