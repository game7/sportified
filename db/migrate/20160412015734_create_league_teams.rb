class CreateLeagueTeams < ActiveRecord::Migration
  def change
    rename_table :teams, :league_teams
  end
end
