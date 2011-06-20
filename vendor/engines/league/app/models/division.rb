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

  before_save do |division|
    division.slug = division.name.parameterize
  end
  before_save do |division|
    if division.persisted? && division.name_changed?
      event = Event.new(:division_renamed)
      event.data[:division_id] = division.id
      event.data[:new_name] = division.name
      EventBus.current.publish(event)       
    end
  end

  scope :with_name, lambda { |name| where(:name => name) }
  scope :with_slug, lambda { |slug| where(:slug => slug) }

  def default_season
    self.current_season ? self.current_season : seasons.desc(:starts_on).first
  end

 
end
