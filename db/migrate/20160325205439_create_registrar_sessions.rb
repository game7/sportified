class CreateRegistrarSessions < ActiveRecord::Migration
  def change
    create_table :registrar_sessions do |t|
      t.references :tenant, index: true
      t.references :registrable, polymorphic: true, index: true
      t.string :title, limit: 30
      t.text :description
      t.integer :registrations_allowed
      t.integer :registrations_available

      t.timestamps null: false
    end
  end
end
