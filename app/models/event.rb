# == Schema Information
#
# Table name: events
#
#  id                        :integer          not null, primary key
#  tenant_id                 :integer
#  league_id                 :integer
#  season_id                 :integer
#  location_id               :integer
#  type                      :string(255)
#  starts_on                 :datetime
#  ends_on                   :datetime
#  duration                  :integer
#  all_day                   :boolean
#  summary                   :string(255)
#  description               :text
#  mongo_id                  :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  home_team_id              :integer
#  away_team_id              :integer
#  statsheet_id              :integer
#  statsheet_type            :string(255)
#  home_team_score           :integer          default(0)
#  away_team_score           :integer          default(0)
#  home_team_name            :string(255)
#  away_team_name            :string(255)
#  home_team_custom_name     :boolean
#  away_team_custom_name     :boolean
#  text_before               :string(255)
#  text_after                :string(255)
#  result                    :string(255)
#  completion                :string(255)
#  exclude_from_team_records :boolean
#

class Event < ActiveRecord::Base
  include Sportified::TenantScoped

  belongs_to :league
  validates_presence_of :league_id

  belongs_to :season
  validates_presence_of :season_id

  belongs_to :location
  # validates_presence_of :location_id

  validates_presence_of :starts_on, :season_id
  before_save :set_starts_on
  def set_starts_on
    self.starts_on = starts_on.change(:hour => 0) if all_day
  end

  validates_presence_of :duration
  validates_numericality_of :duration, :only_integer => true
  before_save :set_duration
  def set_duration
    self.duration = 24 * 60 if all_day
  end

  before_save :set_ends_on
  def set_ends_on
    self.ends_on = all_day ? self.starts_on.change(:day => starts_on.day + 1) : self.starts_on.advance(:minutes => self.duration)
  end

  scope :in_the_past, ->{ where('starts_on < ?', DateTime.now) }
  scope :in_the_future, ->{ where('starts_on > ?', DateTime.now) }
  scope :after, ->(after) { where('starts_on > ?', after) }
  scope :before, ->(before) { where('starts_on < ?', before) }

  class << self
    def for_season(s)
      id = s.class == Season ? s.id : s
      where(:season_id => id)
    end
    def for_league(l)
      id = l.class == League ? l.id : l
      where( :league_id => id)
    end
  end

  def apply_mongo_season_id! season_id
    self.season = Season.unscoped.where(mongo_id: season_id.to_s).first
  end

  def apply_mongo_league_id! league_id
    self.league = League.unscoped.where(mongo_id: league_id.to_s).first
  end

  def apply_mongo_venue_id! venue_id
    # puts "seeking location with mongo_id #{venue_id.to_s}"
    self.location = Location.unscoped.where(mongo_id: venue_id.to_s).first
  end

  def apply_mongo! mongo
    # patch for existing events that currently have nil for location
    # we'll patch the existing event with the first location for the tenant
    unless self.location
      Tenant.current = self.tenant_id
      self.location = Location.first
    end
  end

end
