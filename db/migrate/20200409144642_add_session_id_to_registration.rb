class AddSessionIdToRegistration < ActiveRecord::Migration[5.2]
  def change
    add_column :rms_registrations, :session_id, :text
  end
end
