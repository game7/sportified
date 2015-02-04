class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.references :page
      t.string :type      
      t.integer :section_id
      t.integer :column
      t.integer :position
      t.hstore :options
      
      t.string :mongo_id

      t.timestamps
    end
  end
end
