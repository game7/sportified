class AddTenantIdToUsers < ActiveRecord::Migration[5.2]
  def up
    add_reference :users, :tenant
    User.unscoped.includes(:tenants).all.each do |user|
      user.update_attribute(:tenant_id, user.tenant_ids[0])
    end
    Passwordless::Session
      .unscoped
      .group(:authenticatable_id, :tenant_id)
      .pluck(:authenticatable_id, :tenant_id)
      .each do |user_id, tenant_id|
        User.unscoped.find(user_id).update_attribute(:tenant_id, tenant_id)
    end
    User.unscoped.where(tenant_id: nil).delete_all
    change_column_null :users, :tenant_id, false
    remove_index :users, :email
    add_index :users, [:email, :tenant_id], unique: true
  end

  def down
    remove_reference :users, :tenant
    remove_index :users, [:email, :tenant_id] if index_exists? :users, [:email, :tenant_id]
    remove_index :users, name: :index_users_on_email_and_tenant_id if index_exists? :users, name: :index_users_on_email_and_tenant_id
    add_index :users, :email, unique: true
  end  
end
