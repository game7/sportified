class Season
  include Mongoid::Document
  include Sportified::SiteContext
  cache
 
  field :name  
  field :slug
  field :starts_on, :type => Date

  references_and_referenced_in_many :divisions
  references_many :games
  references_many :teams

  validates_presence_of :name, :starts_on

  class << self
    def most_recent()
      where(:starts_on.lt => DateTime.now).desc(:starts_on).first
    end
  end

  scope :with_name, lambda { |name| where(:name => name) }
  scope :with_slug, lambda { |slug| where(:slug => slug) }

  before_save :set_slug

  private

    def set_slug
      self.slug = self.name.parameterize
    end

end
