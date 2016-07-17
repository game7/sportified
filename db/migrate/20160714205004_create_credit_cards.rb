class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.references :tenant, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :brand, limit: 20
      t.string :country, limit: 2
      t.string :exp_month, limit: 2
      t.string :exp_year, limit: 4
      t.string :funding, limit: 10
      t.string :last4, limit: 4
      t.integer :customer_id
      t.string :token_id

      t.timestamps null: false
    end
    add_index :credit_cards, :customer_id
  end
end
