class Tenant
  include Mongoid::Document
  field :host, :type => String
  field :description, :type => String
  field :analytics_id, :type => String
  
  validates :host, presence: true
  
  class << self
    def current
      Thread.current[:current_tenant] ||= Liga::Tenant.find_or_create_by(:host => '')
    end
    def current=(tenant)
      Thread.current[:current_tenant] = tenant
    end
  end  
end
