class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :uuid
      t.string :first_name
      t.string :last_name
      t.string :email
      t.references :user, foreign_key: true
      t.references :tenant, foreign_key: true
      t.string :session_id
      t.string :payment_intent_id
      t.string :confirmation_code
      t.decimal :total_price, precision: 8, scale: 2
      t.timestamp :completed_at
      t.timestamp :cancelled_at
      t.timestamp :abandoned_at

      t.timestamps
    end
  end
end
