class ChangeCreditCardStripeId < ActiveRecord::Migration[4.2]
  def change
    rename_column :credit_cards, :customer_id, :stripe_card_id
  end
end
