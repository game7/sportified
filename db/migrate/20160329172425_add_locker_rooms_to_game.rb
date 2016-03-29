class AddLockerRoomsToGame < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.references :home_team_locker_room, index: true
      t.references :away_team_locker_room, index: true
    end
  end
end
