class CreatePrograms < ActiveRecord::Migration[4.2]
  def change
    create_table :programs do |t|
      t.references :tenant, index: true, foreign_key: true
      t.string :type
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
