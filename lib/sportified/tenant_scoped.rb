module Sportified
  module TenantScoped
    extend ActiveSupport::Concern
    
    included do
      belongs_to :tenant, class_name: "::Tenant"
      before_validation { self.tenant ||= Tenant.current }
      default_scope Page.tenant_scope
    end
    
    module ClassMethods
      def tenant_scope
        ->{ where(tenant_id: Tenant.current.id) if ::Tenant.current }
      end
      def tenant_criteria
        tenant_scope.call
      end
    end

  end
end