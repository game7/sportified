module Sportified
  module TenantScoped
    extend ActiveSupport::Concern
    
    included do
      belongs_to :tenant, class_name: "::Tenant"
      before_validation { self.tenant ||= Tenant.current }
      default_scope ->{ where(tenant_id: Tenant.current.id) if ::Tenant.current }
    end

  end
end