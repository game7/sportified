class CreatePosts < ActiveRecord::Migration[4.2]
  def change
    create_table :posts do |t|
      t.references :tenant, index: true
      t.string :title
      t.text :summary
      t.text :body
      t.string :link_url
      t.string :image
      
      t.string :mongo_id

      t.timestamps
    end
  end
end
