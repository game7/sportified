class AddPeriodLengthToLeagueDivisions < ActiveRecord::Migration[5.2]
  def change
    add_column :league_divisions, :period_length, :integer, default: 15
  end
end
