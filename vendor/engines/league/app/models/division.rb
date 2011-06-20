class Division
  include Mongoid::Document
  include Sportified::SiteContext
  include Sportified::PublishesMessages
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

  before_save do |division|
    division.slug = division.name.parameterize
  end
  before_save :set_division_renamed_message
  def set_division_renamed_message
    if self.persisted? && self.name_changed?
      msg = Event.new(:division_renamed)
      msg.data[:division_id] = self.id
      msg.data[:division_name] = self.name
      msg.data[:division_slug] = self.slug
      enqueue_message msg
    end
  end

  scope :with_name, lambda { |name| where(:name => name) }
  scope :with_slug, lambda { |slug| where(:slug => slug) }

  def default_season
    self.current_season ? self.current_season : seasons.desc(:starts_on).first
  end

 
end
