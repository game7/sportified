class CreateRmsFields < ActiveRecord::Migration[4.2]
  def change
    create_table :rms_fields do |t|
      t.references :form
      t.string :name, limit: 40
      t.integer :position
      t.hstore :settings

      t.timestamps null: false
    end

    add_foreign_key :rms_fields, :rms_forms, column: :form_id, primary_key: :id
    add_index :rms_fields, [:form_id, :name], :unique => true
  end
end
