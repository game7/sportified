class CreateScreenLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :screen_locations do |t|
      t.references :screen, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end
  end
end
