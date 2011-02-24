class Site
  include Mongoid::Document
  include Mongoid::Timestamps
  cache

  field :name
  field :subdomain
  field :domain
  field :description
  field :analytics_id
  field :analytics_vendor
  field :has_custom_analytics

  embeds_many :blocks

  validates_presence_of :name

  scope :with_domain, lambda { |d| { :where => { :domain => d } } }
  scope :with_subdomain, lambda { |s| { :where => { :subdomain => s } } }

end
