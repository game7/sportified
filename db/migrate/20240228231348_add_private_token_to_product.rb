class AddPrivateTokenToProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :private_token, :string, index: true
  end
end
