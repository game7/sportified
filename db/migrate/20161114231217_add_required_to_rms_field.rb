class AddRequiredToRmsField < ActiveRecord::Migration[4.2]
  def change
    add_column :rms_fields, :required, :boolean
  end
end
