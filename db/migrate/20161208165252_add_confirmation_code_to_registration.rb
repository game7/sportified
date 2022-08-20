class AddConfirmationCodeToRegistration < ActiveRecord::Migration[4.2]
  def change
    add_column :rms_registrations, :confirmation_code, :string
  end
end
