class AddPositionToPlayer < ActiveRecord::Migration[4.2]
  def change
    change_table :players do |t|
      t.string :position
    end
  end
end
