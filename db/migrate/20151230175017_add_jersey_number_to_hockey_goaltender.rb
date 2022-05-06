class AddJerseyNumberToHockeyGoaltender < ActiveRecord::Migration[4.2]
  def change
    change_table :hockey_goaltenders do |t|
      t.string :jersey_number
    end
  end
end
