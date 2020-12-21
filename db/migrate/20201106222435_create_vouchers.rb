class CreateVouchers < ActiveRecord::Migration[5.2]
  def change
    create_table :vouchers do |t|
      t.references :user, foreign_key: true
      t.references :registration, foreign_key: true
      t.integer :amount
      t.datetime :expires_at
      t.datetime :cancelled_at
      t.datetime :comsumed_at

      t.timestamps
    end
  end
end
