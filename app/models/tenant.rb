class Tenant < ActiveRecord::Base
  include Tenancy::Resource
  
  has_and_belongs_to_many :users

  before_save :check_and_set_slug

  validates :name, :slug, presence: true

  scope :for_host, ->(host) { where("host = ?", host) }

  class << self
    def current
      Thread.current[:current_tenant] = Thread.current[:current_tenant] || Tenant.first
    end
    def current=(tenant)
      Thread.current[:current_tenant] = tenant
    end
  end  

  def check_and_set_slug
    self.slug ||= self.host.parameterize
  end
  
  def apply_mongo_user_ids!(user)
    
  end

end
