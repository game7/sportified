class AddPlayingSurfaceToGame < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.references :playing_surface, index: true
    end
  end
end
