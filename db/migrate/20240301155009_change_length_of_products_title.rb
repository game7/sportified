class ChangeLengthOfProductsTitle < ActiveRecord::Migration[7.0]
  def up
    change_column :products, :title, :string
  end

  def down
    change_column :products, :title, :string, limit: 40
  end
end
