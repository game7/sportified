class AddStripeKeysToTenant < ActiveRecord::Migration
  def change
    add_column :tenants, :stripe_secret_api_key, :string
    add_column :tenants, :stripe_public_api_key, :string
  end
end
