class ChangeHockeySkatersToAddDefaults < ActiveRecord::Migration
  def up
    change_column_default :hockey_skaters, :games_played, 0
    change_column_default :hockey_skaters, :goals, 0
    change_column_default :hockey_skaters, :assists, 0
    change_column_default :hockey_skaters, :points, 0
    change_column_default :hockey_skaters, :penalties, 0
    change_column_default :hockey_skaters, :penalty_minutes, 0
    change_column_default :hockey_skaters, :minor_penalties, 0
    change_column_default :hockey_skaters, :major_penalties, 0
    change_column_default :hockey_skaters, :misconduct_penalties, 0
    change_column_default :hockey_skaters, :game_misconduct_penalties, 0
    change_column_default :hockey_skaters, :hat_tricks, 0
    change_column_default :hockey_skaters, :playmakers, 0
    change_column_default :hockey_skaters, :gordie_howes, 0
    change_column_default :hockey_skaters, :ejections, 0
  end
  def down
    change_column_default :hockey_skaters, :games_played, nil
    change_column_default :hockey_skaters, :goals, nil
    change_column_default :hockey_skaters, :assists, nil
    change_column_default :hockey_skaters, :points, nil
    change_column_default :hockey_skaters, :penalties, nil
    change_column_default :hockey_skaters, :penalty_minutes, nil
    change_column_default :hockey_skaters, :minor_penalties, nil
    change_column_default :hockey_skaters, :major_penalties, nil
    change_column_default :hockey_skaters, :misconduct_penalties, nil
    change_column_default :hockey_skaters, :game_misconduct_penalties, nil
    change_column_default :hockey_skaters, :hat_tricks, nil
    change_column_default :hockey_skaters, :playmakers, nil
    change_column_default :hockey_skaters, :gordie_howes, nil
    change_column_default :hockey_skaters, :ejections, nil
  end
end
