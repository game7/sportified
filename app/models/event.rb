# == Schema Information
#
# Table name: events
#
#  id                        :integer          not null, primary key
#  tenant_id                 :integer
#  division_id               :integer
#  season_id                 :integer
#  location_id               :integer
#  type                      :string
#  starts_on                 :datetime
#  ends_on                   :datetime
#  duration                  :integer
#  all_day                   :boolean
#  summary                   :string
#  description               :text
#  mongo_id                  :string
#  created_at                :datetime
#  updated_at                :datetime
#  exclude_from_team_records :boolean
#  playing_surface_id        :integer
#  home_team_locker_room_id  :integer
#  away_team_locker_room_id  :integer
#  program_id                :integer
#
# Indexes
#
#  index_events_on_away_team_locker_room_id  (away_team_locker_room_id)
#  index_events_on_division_id               (division_id)
#  index_events_on_home_team_locker_room_id  (home_team_locker_room_id)
#  index_events_on_location_id               (location_id)
#  index_events_on_mongo_id                  (mongo_id)
#  index_events_on_playing_surface_id        (playing_surface_id)
#  index_events_on_program_id                (program_id)
#  index_events_on_season_id                 (season_id)
#  index_events_on_tenant_id                 (tenant_id)
#
# Foreign Keys
#
#  fk_rails_9a9b98078e  (program_id => programs.id)
#

class Event < ActiveRecord::Base
  include Sportified::TenantScoped

  belongs_to :program
  validates :program_id, presence: true

  belongs_to :location
  # validates_presence_of :location_id

  validates_presence_of :starts_on
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

  def start_time
    self.starts_on
  end

  def module_name
    self.class.name.deconstantize.underscore.presence
  end

end
