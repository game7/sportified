class CreateTenantsAndUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :tenants_users, id: false do |t|
      t.belongs_to :tenant, index: true
      t.belongs_to :user, index: true
    end
  end
end
