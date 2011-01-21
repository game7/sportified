class Team
  include Mongoid::Document

  attr_accessible :_id, :name, :short_name, :show_in_standings
  
  field :name
  field :short_name
  field :slug
  field :breadcrumbs, :type => Array
  field :show_in_standings, :type => Boolean, :default => true

  referenced_in :season, :inverse_of => :teams
  references_many :players  
  references_many :games, :inverse_of => :home_team
  references_many :games, :inverse_of => :away_team
  references_one :record, :class_name => "TeamRecord"

  before_save :set_slug_and_breadcrumbs
  before_save :ensure_short_name
  before_save :ensure_record
  after_create :raise_team_created_event

  scope :with_slug, lambda { |slug| where(:slug => slug) }

  private

    def raise_team_created_event
      @event = Event.new(:team_created)
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

    def set_slug_and_breadcrumbs
      @parent = self.season
      self.slug = self.name.parameterize
      self.breadcrumbs = @parent.breadcrumbs << { :controller => "teams", :id => self.id, :name => self.name, :slug => self.slug }
    end

end
