class CreateRmsEntries < ActiveRecord::Migration[4.2]
  def change
    create_table :rms_entries do |t|
      t.references :form
      t.hstore :data
      t.timestamps null: false
    end

    add_foreign_key :rms_entries, :rms_forms, column: :form_id, primary_key: :id
  end
end
