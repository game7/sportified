class CreateRmsFormFields < ActiveRecord::Migration
  def change
    create_table :rms_form_fields do |t|
      t.references :tenant, index: true, foreign_key: true
      t.references :template
      t.string :type
      t.string :name, limit: 40
      t.integer :position
      t.hstore :properties

      t.timestamps null: false
    end
    add_foreign_key :rms_form_fields, :rms_form_templates, column: :template_id, primary_key: :id
    add_index :rms_form_fields, [:template_id, :name], :unique => true
  end
end
