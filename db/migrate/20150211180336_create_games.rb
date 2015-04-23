class CreateGames < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.references :home_team, index: true
      t.references :away_team, index: true
      t.references :statsheet, polymorphic: true  
      t.integer :home_team_score, default: 0
      t.integer :away_team_score, default: 0
      t.string :home_team_name
      t.string :away_team_name
      t.boolean :home_team_custom_name
      t.boolean :away_team_custom_name
      t.string :text_before
      t.string :text_after
      t.string :result
      t.string :completion
    end  
  end
end
