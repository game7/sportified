class CreateScreens < ActiveRecord::Migration[5.2]
  def change
    create_table :screens do |t|
      t.references :tenant, foreign_key: true
      t.string :name
      t.string :device_key
      t.references :location, foreign_key: true
      t.references :playing_surface, foreign_key: { to_table: :facilities }
      t.datetime :refreshed_at

      t.timestamps
    end
  end
end
