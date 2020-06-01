class AddPrivateToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :private, :boolean
  end
end
