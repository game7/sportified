module Sportified
  module TenantScoped
    extend ActiveSupport::Concern
    
    included do
      include Tenancy::Resource
      include Tenancy::ResourceScope

      scope_to :tenant
        
      def apply_mongo_tenant_id!(tenant_id)
        Tenant.current = self.tenant = Tenant.where(:mongo_id => tenant_id.to_s).first
      end

    end

  end
end