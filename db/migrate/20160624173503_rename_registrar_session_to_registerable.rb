class RenameRegistrarSessionToRegisterable < ActiveRecord::Migration
  def change
    # rename_column :registrar_sessions, :registrable_id, :parent_id
    # rename_column :registrar_sessions, :registrable_type, :parent_type
    # rename_table :registrar_sessions, :registrar_registrables
    # rename_column :registrar_registration_types, :registrar_session_id, :registrable_id
    # add_column :registrar_registrables, :tenant_id, :integer
    # add_index :registrar_registrables, :tenant_id
  end
end
