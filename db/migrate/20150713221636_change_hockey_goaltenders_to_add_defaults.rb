class ChangeHockeyGoaltendersToAddDefaults < ActiveRecord::Migration[4.2]
  def up
    change_column_default :hockey_goaltenders, :games_played, 0
    change_column_default :hockey_goaltenders, :minutes_played, 0
    change_column_default :hockey_goaltenders, :shots_against, 0
    change_column_default :hockey_goaltenders, :goals_against, 0
    change_column_default :hockey_goaltenders, :saves, 0
    change_column_default :hockey_goaltenders, :save_percentage, 0
    change_column_default :hockey_goaltenders, :goals_against_average, 0
    change_column_default :hockey_goaltenders, :shutouts, 0
    change_column_default :hockey_goaltenders, :shootout_attempts, 0
    change_column_default :hockey_goaltenders, :shootout_goals, 0
    change_column_default :hockey_goaltenders, :shootout_save_percentage, 0
    change_column_default :hockey_goaltenders, :regulation_wins, 0
    change_column_default :hockey_goaltenders, :regulation_losses, 0
    change_column_default :hockey_goaltenders, :overtime_wins, 0
    change_column_default :hockey_goaltenders, :overtime_losses, 0
    change_column_default :hockey_goaltenders, :shootout_wins, 0
    change_column_default :hockey_goaltenders, :shootout_losses, 0
    change_column_default :hockey_goaltenders, :total_wins, 0
    change_column_default :hockey_goaltenders, :total_losses, 0    
  end
  def down
    change_column_default :hockey_goaltenders, :games_played, nil
    change_column_default :hockey_goaltenders, :minutes_played, nil
    change_column_default :hockey_goaltenders, :shots_against, nil
    change_column_default :hockey_goaltenders, :goals_against, nil
    change_column_default :hockey_goaltenders, :saves, nil
    change_column_default :hockey_goaltenders, :save_percentage, nil
    change_column_default :hockey_goaltenders, :goals_against_average, nil
    change_column_default :hockey_goaltenders, :shutouts, nil
    change_column_default :hockey_goaltenders, :shootout_attempts, nil
    change_column_default :hockey_goaltenders, :shootout_goals, nil
    change_column_default :hockey_goaltenders, :shootout_save_percentage, nil
    change_column_default :hockey_goaltenders, :regulation_wins, nil
    change_column_default :hockey_goaltenders, :regulation_losses, nil
    change_column_default :hockey_goaltenders, :overtime_wins, nil
    change_column_default :hockey_goaltenders, :overtime_losses, nil
    change_column_default :hockey_goaltenders, :shootout_wins, nil
    change_column_default :hockey_goaltenders, :shootout_losses, nil
    change_column_default :hockey_goaltenders, :total_wins, nil
    change_column_default :hockey_goaltenders, :total_losses, nil    
  end
end
