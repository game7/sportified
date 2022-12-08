class ChangeCreditCardCustomerIdToString < ActiveRecord::Migration[4.2]
  def change
    change_column :credit_cards, :customer_id, :string
  end
end
