class GameResult
  include Mongoid::Document

  COMPLETED_IN = %w[regulation overtime shootout forfeit]
  
  field :played_on, :type => Date
  field :completed_in
  field :home_team_score, :type => Integer
  field :away_team_score, :type => Integer
  field :home_team_points_awarded, :type => Integer
  field :away_team_points_awarded, :type => Integer

end
