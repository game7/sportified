class AddStripeAccountIdToTenant < ActiveRecord::Migration[4.2]
  def change
    rename_column :tenants, :stripe_secret_api_key, :stripe_account_id
  end
end
