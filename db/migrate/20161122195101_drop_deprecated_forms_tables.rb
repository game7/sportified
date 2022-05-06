class DropDeprecatedFormsTables < ActiveRecord::Migration[4.2]
  def up

    drop_table :rms_fields

    remove_foreign_key :rms_registrations, column: :entry_id
    remove_column :rms_registrations, :entry_id
    drop_table :rms_entries

    remove_foreign_key :rms_items, column: :form_id
    remove_column :rms_items, :form_id
    drop_table :rms_forms
    
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
