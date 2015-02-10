class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string :name
      t.string :slug
      t.boolean :show_standings
      t.boolean :show_players
      t.boolean :show_statistics
      t.text :standings_array, array: true, default: []
      t.references :tenant
      
      t.string :mongo_id

      t.timestamps
    end
  end
end
