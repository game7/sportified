class Division
  include Mongoid::Document
  include Sportified::SiteContext
  cache
 
  field :name
  field :slug

  references_and_referenced_in_many :seasons
  referenced_in :current_season, :class_name => "Season"
  referenced_in :standings_layout

  references_many :games
  references_many :teams
  references_many :team_records

  validates_presence_of :name

  before_save :set_slug

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
