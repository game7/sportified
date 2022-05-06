class AddPaymentIdToRegistration < ActiveRecord::Migration[4.2]
  def change
    add_column :registrar_registrations, :payment_id, :string
  end
end
