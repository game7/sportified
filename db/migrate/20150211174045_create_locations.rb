class CreateLocations < ActiveRecord::Migration[4.2]
  def change
    create_table :locations do |t|
      t.references :tenant, index: true
      t.string :name
      t.string :short_name

      t.string :mongo_id

      t.timestamps
    end
  end
end
