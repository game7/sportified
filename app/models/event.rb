
class Event
  include Mongoid::Document
  include Sportified::TenantScoped
  #include Sportified::PublishesMessages

  field :starts_on, :type => DateTime
  validates_presence_of :starts_on, :season_id
  before_save :set_starts_on
  def set_starts_on
    self.starts_on = starts_on.change(:hour => 0) if all_day
  end
  
  field :duration, :type => Integer, :default => 75
  validates_presence_of :duration
  validates_numericality_of :duration, :only_integer => true
  before_save :set_duration
  def set_duration
    self.duration = 24 * 60 if all_day
  end

  field :ends_on, :type => DateTime
  before_save :set_ends_on
  def set_ends_on
    self.ends_on = all_day ? self.starts_on.change(:day => starts_on.day + 1) : self.starts_on.advance(:minutes => self.duration)
  end

  field :all_day, :type => Boolean

  field :summary
  field :description

  referenced_in :venue
  field :venue_name
  field :venue_short_name
  before_save do |event|
    venue = event.venue
    event.venue_name = venue ? venue.name : ''
    event.venue_short_name = venue ? venue.short_name : ''
  end
  
  belongs_to :league
  validates :league_id, presence: true

  belongs_to :season
  validates :season_id, presence: true

  has_and_belongs_to_many :divisions
  has_and_belongs_to_many :teams
  field :show_for_all_teams, :type => Boolean

  scope :in_the_past, :where => { :starts_on.lt => DateTime.now }
  scope :in_the_future, :where => { :starts_on.gt => DateTime.now }
  scope :from, lambda { |from| { :where => { :starts_on.gt => from } } }
  scope :to, lambda { |to| { :where => { :starts_on.lt => to } } }
  scope :between, lambda { |from, to| { :where => { :starts_on.gt => from, :starts_on.lt => to } } }

  class << self  
    def for_team(t)
      id = t.class == Team ? t.id : t
      any_of( { :team_ids => t.id})
    end
    def for_season(s)
      id = s.class == Season ? s.id : s
      where(:season_id => id)
    end
    def for_league(l)
      id = l.class == League ? l.id : l
      where( :league_id => id)
    end
  end

  #before_save :cleanup_division_ids
  #def cleanup_division_ids
  #  division_ids.collect! { |id| BSON::ObjectId(id.to_s) }
  #  division_ids.uniq!
  #end

end
