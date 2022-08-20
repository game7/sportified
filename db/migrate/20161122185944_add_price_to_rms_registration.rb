class AddPriceToRmsRegistration < ActiveRecord::Migration[4.2]
  def change
    add_column :rms_registrations, :price, :decimal, precision: 20, scale: 4
  end
end
