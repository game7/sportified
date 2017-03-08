module Hockey
  module StatsViews

    VIEWS = %w[scoring penalties goaltending]

    SCORING = %w[games_played goals assists points hat_tricks playmakers gordie_howes]
    PENALTIES = %w[games_played penalties penalty_minutes
                   minor_penalties major_penalties misconduct_penalties
                   game_misconduct_penalties ejections]
    GOALTENDING = %w[games_played minutes_played shots_against
                     goals_against goals_against_average saves save_percentage]

  end
end
