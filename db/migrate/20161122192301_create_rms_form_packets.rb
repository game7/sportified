class CreateRmsFormPackets < ActiveRecord::Migration[4.2]
  def change
    create_table :rms_form_packets do |t|
      t.references :tenant, index: true, foreign_key: true
      t.string :name, limit: 40

      t.timestamps null: false
    end
  end
end
