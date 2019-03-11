class AddStripeClientIdToTenant < ActiveRecord::Migration[5.2]
  def change
    add_column :tenants, :stripe_client_id, :string
  end
end
