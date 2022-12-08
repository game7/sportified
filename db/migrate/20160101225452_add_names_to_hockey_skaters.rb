class AddNamesToHockeySkaters < ActiveRecord::Migration[4.2]
  def change
    change_table :hockey_skaters do |t|
      t.string :first_name
      t.string :last_name
    end
  end
end
