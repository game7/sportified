class AddStyleToTenant < ActiveRecord::Migration[5.2]
  def change
    add_column :tenants, :style, :text
  end
end
