class AddLeagueIdToSeasons < ActiveRecord::Migration[4.2]
  def change
    change_table :seasons do |t|
      t.references :league, index: true, references: :programs
    end
    add_foreign_key :seasons, :programs, column: :league_id
  end
end
