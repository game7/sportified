class AddPaymentIntentIdToRegistration < ActiveRecord::Migration[5.2]
  def change
    add_column :rms_registrations, :payment_intent_id, :text
  end
end
