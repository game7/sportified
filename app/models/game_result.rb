class GameResult
  include Mongoid::Document

  COMPLETED_IN = %w[regulation overtime shootout forfeit]

  embedded_in :game, :inverse_of => :result
  
  field :played_on, :type => Date
  field :completed_in
  field :left_team_score, :type => Integer
  field :right_team_score, :type => Integer
  field :left_team_points_awarded, :type => Integer
  field :right_team_points_awarded, :type => Integer

end
