class AddBirthdateToRmsRegistration < ActiveRecord::Migration
  def change
    add_column :rms_registrations, :birthdate, :date
  end
end
