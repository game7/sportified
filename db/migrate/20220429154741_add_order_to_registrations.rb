class AddOrderToRegistrations < ActiveRecord::Migration[5.2]
  def change
    add_reference :registrations, :order
  end
end
