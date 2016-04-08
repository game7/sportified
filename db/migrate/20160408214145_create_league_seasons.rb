class CreateLeagueSeasons < ActiveRecord::Migration
  def change
    rename_table :seasons, :league_seasons
  end
end
