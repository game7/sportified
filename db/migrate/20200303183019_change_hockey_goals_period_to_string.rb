class ChangeHockeyGoalsPeriodToString < ActiveRecord::Migration[5.2]
  def up
    change_column :hockey_goals, :period, :string
  end
  def down
    change_column :hockey_goals, :period, :integer
  end
end
