class AddColorToLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :color, :string
  end
end
