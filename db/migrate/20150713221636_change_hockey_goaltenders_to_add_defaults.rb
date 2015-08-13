class ChangeHockeyGoaltendersToAddDefaults < ActiveRecord::Migration
  def change
    
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
end
