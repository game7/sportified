class UserRole
  include Mongoid::Document
 
  embedded_in :user
  field :name
  field :title
  field :tenant_id
  field :subject_id

  scope :find_by_name, lambda { |name| { :where => { :name => name.to_s } } }

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
