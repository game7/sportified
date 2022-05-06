class RenameRmsFieldsToRmsElements < ActiveRecord::Migration[4.2]
  def change
    rename_table :rms_form_fields, :rms_form_elements
    reversible do |change|
      change.up do
        update "UPDATE rms_form_elements SET type = replace(type, 'FormFields', 'FormElements')"
      end
      change.down do
        update "UPDATE rms_form_fields SET type = replace(type, 'FormElements', 'FormFields')"
      end
    end
  end
end
