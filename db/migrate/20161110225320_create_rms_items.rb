class CreateRmsItems < ActiveRecord::Migration[4.2]
  def change
    create_table :rms_items do |t|
      t.references :parent, polymorphic: true, index: true
      t.string :title, limit: 40
      t.text :description
      t.integer :quantity_allowed
      t.integer :quantity_available
      t.references :tenant, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
