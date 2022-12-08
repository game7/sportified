class DropRegistrarTables < ActiveRecord::Migration[4.2]
  def change
    drop_table :registrar_registrations
    drop_table :registrar_registration_types
    drop_table :registrar_registrables, if_exists: true
  end
end
