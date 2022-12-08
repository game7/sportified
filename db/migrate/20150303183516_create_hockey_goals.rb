class CreateHockeyGoals < ActiveRecord::Migration[4.2]
  def change
    create_table :hockey_goals do |t|
      t.references :tenant, index: true
      t.references :statsheet, index: true

      t.integer :period
      t.integer :minute
      t.integer :second

      t.references :team
      t.references :scored_by
      t.references :scored_on
      t.references :assisted_by
      t.references :also_assisted_by
      t.string :strength

      t.string :mongo_id, index: true
      t.timestamps
    end
  end
end
