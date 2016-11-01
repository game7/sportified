class AddStripeAccessTokenToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :stripe_access_token, :string
  end
end
