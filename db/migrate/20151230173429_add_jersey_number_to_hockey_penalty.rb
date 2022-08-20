class AddJerseyNumberToHockeyPenalty < ActiveRecord::Migration[4.2]
	def change
	    change_table :hockey_penalties do |t|
	      t.string :committed_by_number
	    end 
	end
end
