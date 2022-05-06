class RenameDivisionSeasonsToLeagueDivisionSeasons < ActiveRecord::Migration[4.2]
  def change
    rename_table :divisions_seasons, :league_divisions_seasons
  end
end
