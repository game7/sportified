class AddAdditionalStripeKeysToTenant < ActiveRecord::Migration[5.2]
  def change
    add_column :tenants, :stripe_private_key, :string
    add_column :tenants, :stripe_public_key, :string
  end
end
