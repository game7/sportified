class DropUserRoles < ActiveRecord::Migration[5.2]
  def up
    drop_table :user_roles
  end
end
