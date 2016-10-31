class AddPaymentIdToRegistration < ActiveRecord::Migration
  def change
    add_column :registrar_registrations, :payment_id, :string
  end
end
