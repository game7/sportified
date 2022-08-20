class AddProgramToEvents < ActiveRecord::Migration[4.2]
  def change
    change_table :events do |t|
      t.references :program, index: true, foreign_key: true
    end

    reversible do |dir|
      dir.up do
        ::League::Division.unscoped.each do |division|
          division.events.update_all(program_id: division.program_id)
        end
      end
    end

  end
end
