class RenameDivisionSeasonsToLeagueDivisionSeasons < ActiveRecord::Migration
  def change
    rename_table :divisions_seasons, :league_divisions_seasons
  end
end
