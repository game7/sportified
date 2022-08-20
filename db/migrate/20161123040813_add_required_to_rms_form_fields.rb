class AddRequiredToRmsFormFields < ActiveRecord::Migration[4.2]
  def change
    add_column :rms_form_fields, :required, :boolean
  end
end
