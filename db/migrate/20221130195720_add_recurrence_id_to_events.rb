class AddRecurrenceIdToEvents < ActiveRecord::Migration[5.2]
  def change
    add_reference :events, :recurrence, index: true, foreign_key: true
  end
end
