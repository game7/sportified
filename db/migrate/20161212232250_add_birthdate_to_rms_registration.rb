class AddBirthdateToRmsRegistration < ActiveRecord::Migration[4.2]
  def change
    add_column :rms_registrations, :birthdate, :date
  end
end
