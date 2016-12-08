class AddTimeZoneToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :time_zone, :string, default: 'UTC'
  end
end
