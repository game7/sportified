class AddHintToFormElements < ActiveRecord::Migration[5.0]
  def change
    add_column :rms_form_elements, :hint, :string
  end
end
