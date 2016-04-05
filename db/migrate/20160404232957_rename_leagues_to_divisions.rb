class RenameLeaguesToDivisions < ActiveRecord::Migration
  def change
    rename_table :leagues, :divisions
    rename_table :leagues_seasons, :divisions_seasons
    rename_column :divisions_seasons, :league_id, :division_id
    rename_column :teams, :league_id, :division_id
    rename_column :events, :league_id, :division_id
  end
end
