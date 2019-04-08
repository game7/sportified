class AddActiveFlagToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :rms_items, :active, :boolean
  end
end
