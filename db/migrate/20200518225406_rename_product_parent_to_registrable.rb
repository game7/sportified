class RenameProductParentToRegistrable < ActiveRecord::Migration[5.2]
  def change
    rename_column :products, :parent_id, :registrable_id
    rename_column :products, :parent_type, :registrable_type
  end
end
