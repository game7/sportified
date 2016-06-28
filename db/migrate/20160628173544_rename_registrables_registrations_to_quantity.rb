class RenameRegistrablesRegistrationsToQuantity < ActiveRecord::Migration
  def change
    rename_column :registrar_registrables, :registrations_allowed, :quantity_allowed
    rename_column :registrar_registrables, :registrations_available, :quantity_available
  end
end
