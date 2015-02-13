class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :tenant, index: true
      t.references :league, index: true
      t.references :season, index: true
      t.references :location, index: true
      t.string :type
      t.datetime :starts_on
      t.datetime :ends_on
      t.integer :duration
      t.boolean :all_day
      t.string :summary
      t.text :description
      
      t.string :mongo_id, index: true

      t.timestamps
    end
  end
end
