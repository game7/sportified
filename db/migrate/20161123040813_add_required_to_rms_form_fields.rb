class AddRequiredToRmsFormFields < ActiveRecord::Migration
  def change
    add_column :rms_form_fields, :required, :boolean
  end
end
