module Sportified
  module TenantScoped
    extend ActiveSupport::Concern

    included do
      # include Tenancy::ResourceScope

      # scope_to :tenant

      validates :tenant, presence: true
      belongs_to :tenant

      default_scope -> { where(tenant: Tenant.current_id) }
    end
  end
end
