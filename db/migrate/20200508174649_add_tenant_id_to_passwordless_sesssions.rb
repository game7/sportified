class AddTenantIdToPasswordlessSesssions < ActiveRecord::Migration[5.2]
  def change
    add_reference :passwordless_sessions, :tenant
  end
end
