class AddDeletedAtToRegistrations < ActiveRecord::Migration[5.2]
  def change
    add_column :registrations, :deleted_at, :timestamp
  end
end
