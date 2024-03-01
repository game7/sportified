class AddHideQuantityAvailableToVariants < ActiveRecord::Migration[7.0]
  def change
    add_column :variants, :hide_quantity_available, :boolean, default: false
  end
end
