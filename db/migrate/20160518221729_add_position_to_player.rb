class AddPositionToPlayer < ActiveRecord::Migration
  def change
    change_table :players do |t|
      t.string :position
    end
  end
end
