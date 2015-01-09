class Tenant
  include Mongoid::Document
  before_save :check_and_set_slug
  
  field :name, :type => String
  field :slug, :type => String
  
  field :host, :type => String
  field :description, :type => String
  field :analytics_id, :type => String
  field :theme, :type => String
  
  field :twitter_id, :type => String
  field :facebook_id, :type => String
  field :instagram_id, :type => String
  field :foursquare_id, :type => String
  field :google_plus_id, :type =>String
  
  validates :slug, presence: true
  
  scope :for_host, ->(host) { where(:host => host) }
  
  class << self
    def current
      Thread.current[:current_tenant]
    end
    def current=(tenant)
      Thread.current[:current_tenant] = tenant
    end
  end  
  
  def check_and_set_slug
    self.slug ||= self.host.parameterize
  end
  
end
