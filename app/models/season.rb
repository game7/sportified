class Season
  include Mongoid::Document
  include Sportified::TenantScoped
  cache
 
  field :name  
  field :slug
  field :starts_on, :type => Date

  has_many :divisions
  has_many :teams
  has_many :events

  validates_presence_of :name, :starts_on

  class << self
    def most_recent
      where(:starts_on.lt => DateTime.now).desc(:starts_on).first
    end
    def latest
      desc(:starts_on).first
    end
  end

  scope :with_name, lambda { |name| where(:name => name) }
  scope :with_slug, lambda { |slug| where(:slug => slug) }

  before_save do |season|
    season.slug = season.name.parameterize    
  end

end
