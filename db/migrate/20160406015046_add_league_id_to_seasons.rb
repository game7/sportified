class AddLeagueIdToSeasons < ActiveRecord::Migration
  def change
    change_table :seasons do |t|
      t.references :league, index: true, references: :programs
    end
    add_foreign_key :seasons, :programs, column: :league_id
  end
end
