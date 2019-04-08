class CreateRmsVariants < ActiveRecord::Migration
  def change
    create_table :rms_variants do |t|
      t.references :item
      t.references :tenant, index: true, foreign_key: true
      t.string :title, limit: 40
      t.text :description
      t.decimal :price, precision: 20, scale: 4
      t.integer :quantity_allowed
      t.integer :quantity_available

      t.timestamps null: false
    end

    add_foreign_key :rms_variants, :rms_items, column: :item_id

  end
end
