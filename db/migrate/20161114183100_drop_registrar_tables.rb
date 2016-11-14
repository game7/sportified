class DropRegistrarTables < ActiveRecord::Migration
  def change
    drop_table :registrar_registrations
    drop_table :registrar_registration_types
    drop_table :registrar_registrables
  end
end
