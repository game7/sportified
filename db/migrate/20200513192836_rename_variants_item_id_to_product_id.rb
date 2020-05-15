class RenameVariantsItemIdToProductId < ActiveRecord::Migration[5.2]
  def change
    rename_column :variants, :item_id, :product_id
  end
end
