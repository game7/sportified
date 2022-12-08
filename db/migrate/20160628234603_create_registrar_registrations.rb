class CreateRegistrarRegistrations < ActiveRecord::Migration[4.2]
  def change
    create_table :registrar_registrations do |t|
      t.references :tenant, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :email

      t.timestamps null: false
    end

    add_column :registrar_registrations, :registration_type_id, :integer, index: true
    add_foreign_key :registrar_registrations, :registrar_registration_types, column: :registration_type_id
  end
end
