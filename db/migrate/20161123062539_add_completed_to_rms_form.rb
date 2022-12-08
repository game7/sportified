class AddCompletedToRmsForm < ActiveRecord::Migration[4.2]
  def change
    add_column :rms_forms, :completed, :boolean, null: false, default: false
  end
end
