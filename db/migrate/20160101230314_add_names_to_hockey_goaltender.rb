class AddNamesToHockeyGoaltender < ActiveRecord::Migration
  def change
    change_table :hockey_goaltenders do |t|
      t.string :first_name
      t.string :last_name
    end
  end
end
