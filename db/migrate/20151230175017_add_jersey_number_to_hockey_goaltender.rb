class AddJerseyNumberToHockeyGoaltender < ActiveRecord::Migration
  def change
  	  change_table :hockey_goaltenders do |t|
      t.string :jersey_number
    end 
  end
end
