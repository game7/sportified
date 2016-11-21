class AddRequiredToRmsField < ActiveRecord::Migration
  def change
    add_column :rms_fields, :required, :boolean
  end
end
