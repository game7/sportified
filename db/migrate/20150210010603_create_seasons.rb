class CreateSeasons < ActiveRecord::Migration[4.2]
  def change
    create_table :seasons do |t|
      t.string :name
      t.string :slug
      t.date :starts_on
      t.references :tenant

      t.string :mongo_id

      t.timestamps
    end
  end
end
