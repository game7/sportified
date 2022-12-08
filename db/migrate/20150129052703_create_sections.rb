class CreateSections < ActiveRecord::Migration[4.2]
  def change
    create_table :sections do |t|
      t.references :page, index: true
      t.string :pattern
      t.integer :position
      t.string :mongo_id
      t.timestamps
    end
  end
end
