class Season
  include Mongoid::Document
  include Sportified::SiteContext
  include Sportified::PublishesMessages
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

  before_save do |season|
    season.slug = season.name.parameterize    
  end
  before_save do |season|
    if season.persisted? && season.name_changed?
      msg = Event.new(:season_renamed)
      msg.data[:season_id] = season.id
      msg.data[:season_name] = season.name
      msg.data[:season_slug] = season.slug
      enqueue_message msg     
    end   
  end


end
