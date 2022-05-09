class CreateRmsRegistrations < ActiveRecord::Migration[4.2]
  def change
    create_table :rms_registrations do |t|
      t.references :tenant, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :variant
      t.string :first_name, limit: 40
      t.string :last_name, limit: 40
      t.string :email
      t.string :payment_id

      t.timestamps null: false
    end

    add_foreign_key :rms_registrations, :rms_variants, column: :variant_id

  end
end
