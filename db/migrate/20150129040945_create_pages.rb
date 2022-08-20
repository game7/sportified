class CreatePages < ActiveRecord::Migration[4.2]
  def change
    create_table :pages do |t|
      t.references :tenant, index: true
      t.string :title
      t.string :slug
      t.string :url_path
      t.text :meta_keywords
      t.text :meta_description
      t.string :link_url
      t.boolean :show_in_menu
      t.string :title_in_menu
      t.boolean :skip_to_first_child
      t.boolean :draft
      
      t.string :ancestry
      t.integer :ancestry_depth
      t.index :ancestry
      
      t.integer :position
      
      t.string :mongo_id

      t.timestamps
    end
  end
end
