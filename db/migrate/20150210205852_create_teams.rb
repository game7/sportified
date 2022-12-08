class CreateTeams < ActiveRecord::Migration[4.2]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :short_name
      t.string :slug
      t.boolean :show_in_standings
      t.string :pool
      t.integer :seed

      t.references :tenant, index: true
      t.references :league, index: true
      t.references :season, index: true
      t.references :club, index: true

      t.string :logo

      t.string :primary_color
      t.string :secondary_color
      t.string :accent_color
      t.text :main_colors, array: true, default: []
      t.boolean :custom_colors

      t.integer :crop_x, default: 0
      t.integer :crop_y, default: 0
      t.integer :crop_h, default: 0
      t.integer :crop_w, default: 0

      t.string :mongo_id

      t.timestamps
    end
  end
end
