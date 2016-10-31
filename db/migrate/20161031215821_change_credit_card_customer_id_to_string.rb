class ChangeCreditCardCustomerIdToString < ActiveRecord::Migration
  def change
    change_column :credit_cards, :customer_id, :string
  end
end
