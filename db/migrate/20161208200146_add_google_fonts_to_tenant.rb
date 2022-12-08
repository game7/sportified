class AddGoogleFontsToTenant < ActiveRecord::Migration[4.2]
  def change
    add_column :tenants, :google_fonts, :string
  end
end
