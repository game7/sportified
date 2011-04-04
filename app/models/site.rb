class Site
  include Mongoid::Document
  include Mongoid::Timestamps
  cache

  before_create :set_slug

  field :name
  field :host
  field :slug
  field :description
  field :analytics_id
  field :has_custom_analytics

  references_and_referenced_in_many :users

  validates_presence_of :name, :host

  scope :for_host, lambda { |h| { :where => { :host => h } } }

  def set_slug
    self.slug = name.parameterize
  end

  class << self
    def current
      Thread.current[:current_site]
    end
    def current=(site)
      Thread.current[:current_site] = site
    end
  end

end
