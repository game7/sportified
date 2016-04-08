class CreateLeagueDivisions < ActiveRecord::Migration
  def change
    rename_table :divisions, :league_divisions
  end
end
