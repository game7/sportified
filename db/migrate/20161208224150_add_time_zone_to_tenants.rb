class AddTimeZoneToTenants < ActiveRecord::Migration[4.2]
  def change
    add_column :tenants, :time_zone, :string, default: 'UTC'
  end
end
