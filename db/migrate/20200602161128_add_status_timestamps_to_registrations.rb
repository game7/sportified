class AddStatusTimestampsToRegistrations < ActiveRecord::Migration[5.2]
  def change
    add_column :registrations, :completed_at, :datetime
    add_column :registrations, :abandoned_at, :datetime
    add_column :registrations, :cancelled_at, :datetime
  end
end
