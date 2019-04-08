class AddConfirmationCodeToRegistration < ActiveRecord::Migration
  def change
    add_column :rms_registrations, :confirmation_code, :string
  end
end
