class CreateRmsFormTemplates < ActiveRecord::Migration[4.2]
  def change
    create_table :rms_form_templates do |t|
      t.references :tenant, index: true, foreign_key: true
      t.references :packet
      t.string :name, limit: 40
      t.integer :position

      t.timestamps null: false
    end
    add_foreign_key :rms_form_templates, :rms_form_packets, column: :packet_id, primary_key: :id
  end
end
