class AddJerseyNumberToHockeyPenalty < ActiveRecord::Migration
	def change
	    change_table :hockey_penalties do |t|
	      t.string :committed_by_number
	    end 
	end
end
