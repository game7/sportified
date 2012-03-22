class Tenant
  include Mongoid::Document
  field :name, :type => String
  field :host, :type => String
  field :description, :type => String
  field :analytics_id, :type => String
  field :theme, :type => String
  
  validates :host, presence: true
  
  scope :for_host, lambda { |host| { :where => { :host => host } } }
  
  class << self
    def current
      Thread.current[:current_tenant] ||= Tenant.find_or_create_by(:host => '')
    end
    def current=(tenant)
      Thread.current[:current_tenant] = tenant
    end
  end  
end
