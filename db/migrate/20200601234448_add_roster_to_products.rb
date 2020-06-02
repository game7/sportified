class AddRosterToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :roster, :boolean
  end
end
