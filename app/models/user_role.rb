# == Schema Information
#
# Table name: user_roles
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  name       :string
#  title      :string
#  tenant_id  :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_user_roles_on_user_id  (user_id)
#

class UserRole < ActiveRecord::Base

  belongs_to :user
  belongs_to :tenant, required: false

  # scope :find_by_name, ->(name) { where(:name => name.to_s) }

  class << self
    def for_tenant(t)
      id = t.class == Tenant ? t.id : t
      where(:tenant_id => id)
    end
    def super_admin
      UserRole.new(:name => "super_admin", :title => "Super Admin")
    end
    def admin(tenant)
      UserRole.new(:name => "admin", :title => "Admin", :tenant_id => tenant.id)
    end
  end

end
