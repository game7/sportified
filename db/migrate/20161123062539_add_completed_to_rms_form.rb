class AddCompletedToRmsForm < ActiveRecord::Migration
  def change
    add_column :rms_forms, :completed, :boolean, null: false, default: false
  end
end
