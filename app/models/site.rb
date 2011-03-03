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

  references_and_referenced_in_many :users

  embeds_many :blocks

  validates_presence_of :name, :domain

  scope :with_domain, lambda { |d| { :where => { :domain => d } } }
  scope :with_subdomain, lambda { |s| { :where => { :subdomain => s } } }

  class << self
    def current
      Thread.current[:current_site]
    end
    def current=(site)
      Thread.current[:current_site] = site
    end
  end

end
