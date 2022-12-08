class CreateLeaguePrograms < ActiveRecord::Migration[4.2]
  def up
    Program.unscoped.where(type: 'League').update_all(type: 'League::Program')

    remove_foreign_key :divisions, column: :league_id
    rename_column :divisions, :league_id, :program_id
    add_foreign_key :divisions, :programs

    remove_foreign_key :seasons, column: :league_id
    rename_column :seasons, :league_id, :program_id
    add_foreign_key :seasons, :programs
  end

  def down
    Program.unscoped.where(type: 'League::Program').update_all(type: 'League')

    remove_foreign_key :divisions, :programs
    rename_column :divisions, :program_id, :league_id
    add_foreign_key :divisions, :programs, column: :league_id

    remove_foreign_key :seasons, :programs
    rename_column :seasons, :program_id, :league_id
    add_foreign_key :seasons, :programs, column: :league_id
  end
end
