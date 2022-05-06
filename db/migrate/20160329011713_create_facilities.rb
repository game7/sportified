class CreateFacilities < ActiveRecord::Migration[4.2]
  def change
    create_table :facilities do |t|
      t.string :type
      t.string :name
      t.references :tenant, index: true
      t.references :location, index: true, foreign_key: true
      t.references :parent, index: true

      t.timestamps null: false
    end
  end
end
