class CreatePlayers < ActiveRecord::Migration[4.2]
  def change
    create_table :players do |t|
      t.references :tenant, index: true
      t.references :team, index: true
      t.string :first_name
      t.string :last_name
      t.string :jersey_number
      t.date :birthdate
      t.string :email
      t.string :slug
      
      t.string :mongo_id, index: true

      t.timestamps
    end
  end
end
