class AddCheckedInAtToRegistrations < ActiveRecord::Migration[5.2]
  def change
    add_column :registrations, :checked_in_at, :datetime
  end
end
