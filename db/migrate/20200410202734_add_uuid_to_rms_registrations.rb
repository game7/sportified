class AddUuidToRmsRegistrations < ActiveRecord::Migration[5.2]
  def change
    add_column :rms_registrations, :uuid, :string, unique: true
  end
end
