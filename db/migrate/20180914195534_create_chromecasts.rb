class CreateChromecasts < ActiveRecord::Migration[5.0]
  def change
    create_table :chromecasts do |t|
      t.string :name
      t.references :tenant, foreign_key: true
      t.references :location, foreign_key: true
      t.references :playing_surface, foreign_key: { to_table: :facilities }

      t.timestamps
    end
  end
end
