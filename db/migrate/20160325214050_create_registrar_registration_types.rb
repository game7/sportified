class CreateRegistrarRegistrationTypes < ActiveRecord::Migration
  def change
    create_table :registrar_registration_types do |t|
      t.references :tenant, index: true
      # t.references :registrar_session, index: true, foreign_key: true
      t.string :title, limit: 30
      t.text :description
      t.decimal :price, precision: 20, scale: 4
      t.integer :quantity_allowed
      t.integer :quantity_available

      t.timestamps null: false
    end
  end
end
