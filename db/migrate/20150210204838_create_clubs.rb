class CreateClubs < ActiveRecord::Migration[4.2]
  def change
    create_table :clubs do |t|
      t.string :name
      t.string :short_name
      t.references :tenant, index: true

      t.string :mongo_id

      t.timestamps
    end
  end
end
