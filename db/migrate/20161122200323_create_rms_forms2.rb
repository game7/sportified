class CreateRmsForms2 < ActiveRecord::Migration[4.2]
  def change
    create_table :rms_forms do |t|
      t.references :tenant, index: true, foreign_key: true
      t.references :registration
      t.references :template
      t.hstore :data

      t.timestamps null: false
    end
    add_foreign_key :rms_forms, :rms_form_templates, column: :template_id, primary_key: :id
    add_foreign_key :rms_forms, :rms_registrations, column: :registration_id, primary_key: :id
  end
end
