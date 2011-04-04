class Season
  include Mongoid::Document
  cache
 
  field :name  
  field :slug
  field :starts_on, :type => Date

  referenced_in :site
  references_and_referenced_in_many :divisions
  references_many :games
  references_many :teams

  validates_presence_of :name, :starts_on, :site_id

  class << self
    def for_site(s)
      id = s.class == Site ? s.id : s
      where(:site_id => id)
    end
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
