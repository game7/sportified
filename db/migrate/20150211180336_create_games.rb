class CreateGames < ActiveRecord::Migration
  def change
    add_reference :events, :home_team, index: true
    add_reference :events, :away_team, index: true
    add_column :events, :home_team_score, :integer, default: 0
    add_column :events, :away_team_score, :integer, default: 0
    add_column :events, :home_team_name, :string
    add_column :events, :away_team_name, :string
    add_column :events, :home_team_custom_name, :boolean
    add_column :events, :away_team_custom_name, :boolean
    add_column :events, :text_before, :string
    add_column :events, :text_after, :string
    add_column :events, :result, :string
    add_column :events, :completion, :string
  end
end
