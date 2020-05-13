class RenameRmsTables < ActiveRecord::Migration[5.2]
  def change
    rename_table :rms_items, :products
    rename_table :rms_variants, :variants
    rename_table :rms_registrations, :registrations
    rename_table :rms_forms, :forms
    rename_table :rms_form_elements, :form_elements
    rename_table :rms_form_packets, :form_packets
    rename_table :rms_form_templates, :form_templates
  end
end
