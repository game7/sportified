class Site
  include Mongoid::Document
  include Mongoid::Timestamps
  cache

  field :name
  field :host
  field :description
  field :analytics_id
  field :analytics_vendor
  field :has_custom_analytics

  references_and_referenced_in_many :users

  embeds_many :blocks

  validates_presence_of :name, :host

  scope :for_host, lambda { |h| { :where => { :host => h } } }

  class << self
    def current
      Thread.current[:current_site]
    end
    def current=(site)
      Thread.current[:current_site] = site
    end
  end

end
