class CreateHockeyStatsheets < ActiveRecord::Migration[4.2]
  def change
    create_table :hockey_statsheets do |t|
      
      t.references :tenant, index: true
      t.boolean :posted
      
      t.integer :away_score
      t.integer :home_score

      t.string :latest_period
      t.integer :latest_minute
      t.integer :latest_second

      t.integer :min_1
      t.integer :min_2
      t.integer :min_3
      t.integer :min_ot
      
      t.integer :away_shots_1
      t.integer :away_shots_2
      t.integer :away_shots_3
      t.integer :away_shots_ot
      t.integer :home_shots_1
      t.integer :home_shots_2
      t.integer :home_shots_3
      t.integer :home_shots_ot
      
      t.string :mongo_id, index: true

      t.timestamps
    end
  end
end
