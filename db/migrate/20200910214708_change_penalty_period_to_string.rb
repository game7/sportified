class ChangePenaltyPeriodToString < ActiveRecord::Migration[5.2]
  def up
    change_column :hockey_penalties, :period, :string
  end
  def down
    change_column :hockey_penalties, :period, :integer
  end  
end
