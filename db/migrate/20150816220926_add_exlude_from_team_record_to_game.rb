class AddExludeFromTeamRecordToGame < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.boolean :exclude_from_team_records
    end  
  end
end
