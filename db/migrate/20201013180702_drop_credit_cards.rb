class DropCreditCards < ActiveRecord::Migration[5.2]
  def up
    remove_column :registrations, :credit_card_id
    drop_table :credit_cards
  end
end
