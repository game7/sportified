class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.integer :user_id
      t.string :name
      t.string :title
      t.integer :tenant_id
      t.timestamps
      t.string :mongo_id
    end
    add_index :user_roles, :user_id
  end
end
