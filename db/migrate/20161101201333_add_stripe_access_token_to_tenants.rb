class AddStripeAccessTokenToTenants < ActiveRecord::Migration[4.2]
  def change
    add_column :tenants, :stripe_access_token, :string
  end
end
