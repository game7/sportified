class AddFormIdToRmsItem < ActiveRecord::Migration[4.2]
  def change
    add_column :rms_items, :form_id, :integer
    add_foreign_key :rms_items, :rms_forms, column: :form_id, primary_key: :id
  end
end
