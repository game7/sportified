module Sportified
  module TenantScoped
    extend ActiveSupport::Concern
    
    included do
      belongs_to :tenant, class_name: "::Tenant"
      before_validation { self.tenant ||= Tenant.current }
    end
    
    module ClassMethods
      def tenant_scope
        { :where => { :tenant_id => Tenant.current.id } } if ::Tenant.current
      end
      def criteria(embedded = false, scoped = true)
        (scope_stack.last || Mongoid::Criteria.new(self, embedded)).tap do |crit|
          return crit.apply_default_scope.fuse(tenant_scope) if scoped
        end
      end
      def is_tenant_scoped?
        true
      end
    end
  end
end