class Division
  include Mongoid::Document
  cache
 
  field :name
  field :slug

  referenced_in :site
  references_and_referenced_in_many :seasons
  referenced_in :current_season, :class_name => "Season"

  references_many :games
  references_many :teams
  references_many :team_records

  validates_presence_of :name
  validates_presence_of :site_id

  embeds_many :standings_columns, :class_name => "StandingsColumn"

  before_save :set_slug

  class << self
    def for_site(s)
      id = s.class == Site ? s.id : s
      where(:site_id => id)
    end
  end

  scope :with_name, lambda { |name| where(:name => name) }
  scope :with_slug, lambda { |slug| where(:slug => slug) }

  def default_season
    self.current_season ? self.current_season : seasons.desc(:starts_on).first
  end

  private

    def set_slug
      self.slug = self.name.parameterize
    end
 
end
