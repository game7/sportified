class CreateStripeConnects < ActiveRecord::Migration[5.2]
  def change
    create_table :stripe_connects do |t|
      t.references :tenant, foreign_key: true      
      t.string :referrer
      t.string :token, unique: true
      t.string :client
      t.string :redirect
      t.string :status
      t.string :result

      t.timestamps
    end
  end
end
