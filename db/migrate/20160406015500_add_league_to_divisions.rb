class AddLeagueToDivisions < ActiveRecord::Migration[4.2]
  def change
    change_table :divisions do |t|
      t.references :league, index: true, references: :programs
    end
    add_foreign_key :divisions, :programs, column: :league_id
  end
end
