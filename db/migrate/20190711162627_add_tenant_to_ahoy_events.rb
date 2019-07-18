class AddTenantToAhoyEvents < ActiveRecord::Migration[5.2]
  def change
    add_reference :ahoy_events, :tenant
  end
end
