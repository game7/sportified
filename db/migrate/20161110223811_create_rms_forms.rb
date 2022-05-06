class CreateRmsForms < ActiveRecord::Migration[4.2]
  def change
    create_table :rms_forms do |t|
      t.string :name, limit: 40
      t.references :tenant, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
