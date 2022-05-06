class CreateHockeyGoaltenders < ActiveRecord::Migration[4.2]
  def change
   create_table :hockey_goaltenders do | t |
      t.string :type
      t.references :tenant, index: true
      t.references :team, index: true
      t.references :player, index: true
      t.references :statsheet, index: true
      
      t.integer :games_played
      t.integer :minutes_played
      t.integer :shots_against
      t.integer :goals_against
      t.integer :saves
      t.float :save_percentage
      t.float :goals_against_average
      t.integer :shutouts
      t.integer :shootout_attempts
      t.integer :shootout_goals
      t.float :shootout_save_percentage
      t.integer :regulation_wins
      t.integer :regulation_losses
      t.integer :overtime_wins
      t.integer :overtime_losses
      t.integer :shootout_wins
      t.integer :shootout_losses
      t.integer :total_wins
      t.integer :total_losses
      
      t.string :mongo_id, index: true      
      
      t.timestamps
    end
  end
end
