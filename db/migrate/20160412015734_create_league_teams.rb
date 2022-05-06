class CreateLeagueTeams < ActiveRecord::Migration[4.2]
  def change
    rename_table :teams, :league_teams
  end
end
