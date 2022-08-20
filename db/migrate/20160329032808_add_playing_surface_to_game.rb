class AddPlayingSurfaceToGame < ActiveRecord::Migration[4.2]
  def change
    change_table :events do |t|
      t.references :playing_surface, index: true
    end
  end
end
