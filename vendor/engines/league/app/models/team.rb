class Team
  include Mongoid::Document
  cache

  attr_accessible :_id, :name, :short_name, :season_id, :division_id
  
  field :name
  field :short_name
  field :slug
  field :show_in_standings, :type => Boolean, :default => true

  referenced_in :division
  referenced_in :season
  references_many :players  
  references_many :games, :inverse_of => :home_team
  references_many :games, :inverse_of => :away_team
  references_one :record, :class_name => "TeamRecord", :dependent => :delete

  validates_presence_of :name
  validates_presence_of :division_id
  validates_presence_of :season_id

  before_save :set_slug
  before_save :ensure_short_name
  before_save :ensure_record
  after_create :raise_team_created_event

  class << self
    def for_season(season)
      season_id = ( season.class == Season ? season.id : season )
      where(:season_id => season_id)
    end
    def for_division(division)
      division_id = ( division.class == Division ? division.id : division )
      where(:division_id => division_id)
    end
  end
  scope :with_slug, lambda { |slug| where(:slug => slug) }

  private

    def raise_team_created_event
      @event = Event.new(:team_created)
      @event.data[:division_id] = self.division_id
      @event.data[:season_id] = self.season_id
      @event.data[:team_id] = self.id
      @event.data[:team_name] = self.name
      @event.data[:team_short_name] = self.short_name
      EventBus.current.publish(@event)      
    end

    def ensure_short_name
      if self.short_name.nil? || self.short_name.empty?
        self.short_name = self.name
      end
    end

    def ensure_record
      self.record ||= TeamRecord.new
    end

    def set_slug
      self.slug = self.name.parameterize
    end

end
