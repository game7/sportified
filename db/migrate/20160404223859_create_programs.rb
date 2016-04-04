class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.references :tenant, index: true, foreign_key: true
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
