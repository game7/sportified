class Team::Record::Result
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
    if (params && params[:game] && params[:team])
      self.load_from_game(params[:team], params[:game]) if params[:game] && params[:team]
    end
  end

  def load_from_game(team, game)
    
    team_id = team.class == Team ? team.id : team

    self.game_id = game.id    
    self.played_on = game.starts_on.to_date
    self.completed_in = game.result.completed_in

    if game.away_team.id == team_id
      self.opponent_id = game.home_team_id
      self.opponent_name = game.home_team_name
      self.scored = game.result.away_score
      self.allowed = game.result.home_score
    elsif game.home_team.id == team_id
      self.opponent_id = game.away_team_id
      self.opponent_name = game.away_team_name
      self.scored = game.result.home_score
      self.allowed = game.result.away_score
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
