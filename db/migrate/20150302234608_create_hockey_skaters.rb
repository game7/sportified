class CreateHockeySkaters < ActiveRecord::Migration[4.2]
  def change
    create_table :hockey_skaters do |t|
      t.string :type
      t.references :tenant, index: true
      t.references :team, index: true
      t.references :player, index: true
      t.references :statsheet, index: true
      
      t.string :jersey_number
      t.integer :games_played
      t.integer :goals
      t.integer :assists
      t.integer :points
      t.integer :penalties
      t.integer :penalty_minutes
      t.integer :minor_penalties
      t.integer :major_penalties
      t.integer :misconduct_penalties
      t.integer :game_misconduct_penalties
      t.integer :hat_tricks
      t.integer :playmakers
      t.integer :gordie_howes
      t.integer :ejections
      
      t.string :mongo_id, index: true
      
      t.timestamps
    end
  end
end
