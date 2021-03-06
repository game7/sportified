class AddCreditCardIdToRegistration < ActiveRecord::Migration
  def change
    add_column :registrar_registrations, :credit_card_id, :integer, index: true
    add_foreign_key :registrar_registrations, :credit_cards, column: :credit_card_id
  end
end
