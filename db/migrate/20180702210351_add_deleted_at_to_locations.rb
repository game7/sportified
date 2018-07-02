class AddDeletedAtToLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :deleted_at, :datetime
    add_index :locations, :deleted_at
  end
end
