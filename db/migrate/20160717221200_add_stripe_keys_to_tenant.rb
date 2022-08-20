class AddStripeKeysToTenant < ActiveRecord::Migration[4.2]
  def change
    add_column :tenants, :stripe_secret_api_key, :string
    add_column :tenants, :stripe_public_api_key, :string
  end
end
