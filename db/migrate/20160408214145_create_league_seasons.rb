class CreateLeagueSeasons < ActiveRecord::Migration[4.2]
  def change
    rename_table :seasons, :league_seasons
  end
end
