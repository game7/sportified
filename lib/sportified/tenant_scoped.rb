module Sportified
  module TenantScoped
    extend ActiveSupport::Concern
    
    included do
      include Tenancy::ResourceScope

      scope_to :tenant

    end

  end
end