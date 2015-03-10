module Sportified
  module TenantScoped
    extend ActiveSupport::Concern
    
    included do
      include Tenancy::Resource
      include Tenancy::ResourceScope

      scope_to :tenant
      index tenant_id: 1
    end

  end
end