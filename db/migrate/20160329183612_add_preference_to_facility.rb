class AddPreferenceToFacility < ActiveRecord::Migration[4.2]
  def change
    change_table :facilities do |t|
      t.string :preference
    end
  end
end
