class TeamRecord
  include Mongoid::Document

  field :games_played, :type => Integer, :default => 0
  field :wins, :type => Integer, :default => 0
  field :losses, :type => Integer, :default => 0
  field :ties, :type => Integer, :default => 0
  field :points, :type => Integer, :default => 0
  field :win_percentage, :type => Float, :default => 0.00
  field :goals_scored, :type => Integer, :default => 0
  field :goals_allowed, :type => Integer, :default => 0
  field :goal_differential, :type => Integer, :default => 0

  embedded_in :team, :inverse_of => :record
  embeds_many :results, :class_name => 'TeamGameResult'


  def post_result_from_game(game)

    raise 'Game already posted to team record' if is_game_posted?(game)

    @team_game_result = TeamGameResult.new(:team => self.team, :game => game)
    apply_team_game_result(@team_game_result)
    self.results << @team_game_result
    
  end

  def cancel_result_for_game(game_id)
    @result = self.results.find(:first, :conditions => { :game_id => game_id })
    if @result
      remove_team_game_result(result)
      result.delete
    end
  end

  def is_game_posted?(game)
    results.where(:game_id => game.id).count > 0
  end

  def apply_team_game_result(result)
    self.games_played += 1
    case
      when result.decision = 'win' then self.wins += 1
      when result.decision = 'loss' then self.losses += 1
      when result.decision = 'tie' then self.ties += 1
    end
    self.update_points!
    self.update_win_percentage!
    
    self.goals_scored += result.goals_scored
    self.goals_allowed += result.goals_allowed
    self.update_goal_differential!

    self.results << result    
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
    
    self.goals_scored -= result.goals_scored
    self.goals_allowed -= result.goals_allowed
    self.update_goal_differential!    
  end

  def update_goal_differential!
    self.goal_differential = self.goals_scored - self.goals_allowed
  end

  def update_points!
    self.points = (2 * self.wins) + (1 * self.ties)
  end

  def update_win_percentage!
    @pct = self.games_played > 0 ? self.wins / self.games_played : 0.00
  end

end
