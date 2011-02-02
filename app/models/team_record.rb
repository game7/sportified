class TeamRecord
  include Mongoid::Document

  field :team_name
  field :games_played, :type => Integer, :default => 0
  field :wins, :type => Integer, :default => 0
  field :losses, :type => Integer, :default => 0
  field :ties, :type => Integer, :default => 0
  field :points, :type => Integer, :default => 0
  field :win_percentage, :type => Float, :default => 0.00
  field :scored, :type => Integer, :default => 0
  field :allowed, :type => Integer, :default => 0
  field :margin, :type => Integer, :default => 0
  field :last_decision
  field :streak, :type => Integer, :default => 0
  field :owp, :type => Float, :default => 0.00
  field :oowp, :type => Float, :default => 0.00
  field :sos, :type => Float, :default => 0.00
  field :rpi, :type => Float, :default => 0.00

  referenced_in :season, :inverse_of => :team_records
  referenced_in :team, :inverse_of => :record
  embeds_many :results, :class_name => 'TeamGameResult'

  scope :for_team_id, lambda { |team_id| where(:team_id => team_id)}

  def reset!
    self.games_played = 0
    self.wins = 0
    self.losses = 0
    self.ties = 0
    self.points = 0
    self.win_percentage = 0.00
    self.scored = 0
    self.allowed = 0
    self.margin = 0
    self.last_decision = nil
    self.streak = 0
    self.owp = 0.00
    self.oowp = 0.00
    self.sos = 0.00
    self.rpi = 0.00
    self.results.each{ |r| r.delete }
  end

  def post_result_from_game(game)

    raise 'Game already posted to team record' if is_game_posted?(game)

    @team_game_result = TeamGameResult.new(:team_id => self.team_id, :game => game)
    apply_team_game_result(@team_game_result)
    
  end

  def cancel_result_for_game(game)
    @result = self.results.where( :game_id => game.id ).first
    if @result
      @result.delete      
      remove_team_game_result(@result)
    end
  end

  def is_game_posted?(game)
    results.where(:game_id => game.id).count > 0
  end

  def apply_team_game_result(result)
    
    self.games_played += 1
    case
      when result.decision == 'win' then self.wins += 1
      when result.decision == 'loss' then self.losses += 1
      when result.decision == 'tie' then self.ties += 1
    end
    self.update_points!
    self.update_win_percentage!
    
    self.scored += result.scored
    self.allowed += result.allowed
    self.update_margin!

    self.results << result 

    self.update_streak!  
  end

  def remove_team_game_result(result)
    self.games_played -= 1
    case
      when result.decision = 'win' then self.wins -= 1
      when result.decision = 'loss' then self.losses -= 1
      when result.decision = 'tie' then self.ties -= 1
    end
    self.update_points!
    self.update_win_percentage!
    
    self.scored -= result.scored
    self.allowed -= result.allowed
    self.update_margin!  
    self.update_streak!  
  end

  def update_margin!
    self.margin = self.scored - self.allowed
  end

  def update_points!
    self.points = (2 * self.wins) + (1 * self.ties)
  end

  def update_win_percentage!
    self.win_percentage = self.games_played > 0 ? self.wins.fdiv(self.games_played) : 0.00
  end

  def update_streak!
    self.streak = 0
    results.desc(:played_on).each_with_index do |result, index|
      self.last_decision = result.decision if index == 0
      break unless self.last_decision == result.decision 
      self.streak += 1
    end
  end

end
