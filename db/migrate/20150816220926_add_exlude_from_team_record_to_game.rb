class AddExludeFromTeamRecordToGame < ActiveRecord::Migration[4.2]
  def change
    change_table :events do |t|
      t.boolean :exclude_from_team_records
    end
  end
end
