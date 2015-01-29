class CreateTenant < ActiveRecord::Migration
  def change
    create_table :tenants do |t|
      t.string :name
      t.string :slug
      t.string :host
      t.text :description
      t.string :analytics_id
      t.string :theme
      t.string :twitter_id
      t.string :facebook_id
      t.string :instagram_id
      t.string :foursquare_id
      t.string :google_plus_id
      t.string :mongo_id
      t.timestamps
    end
  end
end
