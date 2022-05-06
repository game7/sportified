class CreateLeagueDivisions < ActiveRecord::Migration[4.2]
  def change
    rename_table :divisions, :league_divisions
  end
end
