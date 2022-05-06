class AddJerseyNumbersToHockeyGoals < ActiveRecord::Migration[4.2]
  def change
    change_table :hockey_goals do |t|
      t.string :scored_by_number
      t.string :assisted_by_number
      t.string :also_assisted_by_number
    end    
  end
end
