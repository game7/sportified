class AddDisplayOrderToVariants < ActiveRecord::Migration[5.2]
  def change
    add_column :variants, :display_order, :integer, default: 0
  end
end
