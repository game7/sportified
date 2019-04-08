class AddPriceToRmsRegistration < ActiveRecord::Migration
  def change
    add_column :rms_registrations, :price, :decimal, precision: 20, scale: 4
  end
end
