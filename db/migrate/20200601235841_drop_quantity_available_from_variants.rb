class DropQuantityAvailableFromVariants < ActiveRecord::Migration[5.2]
  def change
    remove_column :variants, :quantity_available, :boolean
  end
end
