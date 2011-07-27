
class Event
  include Mongoid::Document
  include Sportified::SiteContext
  include Sportified::PublishesMessages

  field :starts_on, :type => DateTime
  validates_presence_of :starts_on, :season_id
  
  field :duration, :type => Integer, :default => 75
  validates_presence_of :duration
  validates_numericality_of :duration, :only_integer => true

  field :ends_on, :type => DateTime
  before_save :set_ends_on
  def set_ends_on
    self.ends_on = self.starts_on.advance(:minutes => self.duration)
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

  referenced_in :season
  validates_presence_of :season_id

  field :division_ids, :type => Array, :default => []
  field :show_for_all_teams, :type => Boolean
  field :team_ids, :type => Array, :default => []

  scope :in_the_past, :where => { :starts_on.lt => DateTime.now }
  scope :in_the_future, :where => { :starts_on.gt => DateTime.now }
  scope :from, lambda { |from| { :where => { :starts_on.gt => from } } }
  scope :to, lambda { |to| { :where => { :starts_on.lt => to } } }
  scope :between, lambda { |from, to| { :where => { :starts_on.gt => from, :starts_on.lt => to } } }

  class << self  
    def for_team(t)
      id = t.class == Team ? t.id : t
      #where( :team_ids => id )
      #any_in( :team_ids => [id] )
      any_of( { :team_ids => t.id}, { :division_ids => t.division_id, :show_for_all_teams => true })
      #any_of( { "left_team_id" => id }, { "right_team_id" => id } )
    end
    def for_season(s)
      id = s.class == Season ? s.id : s
      where(:season_id => id)
    end
    def for_division(d)
      id = d.class == Division ? d.id : d
      any_in( :division_ids => [id])
    end
  end

end
