class AddTenantToAhoyVisits < ActiveRecord::Migration[5.2]
  def change
    add_reference :ahoy_visits, :tenant
  end
end
