class AddJerseyNumberToHockeyPenalty < ActiveRecord::Migration
    change_table :hockey_penalties do |t|
      t.string :committed_by_number
    end 
end
