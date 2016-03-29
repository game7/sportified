class AddPreferenceToFacility < ActiveRecord::Migration
  def change
    change_table :facilities do |t|
      t.string :preference
    end
  end
end
