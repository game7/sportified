class AddEntryIdToRmsRegistration < ActiveRecord::Migration[4.2]
  def change
    add_reference :rms_registrations, :entry
    add_foreign_key :rms_registrations, :rms_entries, column: :entry_id, primary_key: :id
  end
end
