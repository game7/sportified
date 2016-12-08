class AddGoogleFontsToTenant < ActiveRecord::Migration
  def change
    add_column :tenants, :google_fonts, :string
  end
end
