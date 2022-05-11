# == Schema Information
#
# Table name: events
#
#  id                        :integer          not null, primary key
#  all_day                   :boolean
#  away_team_custom_name     :boolean
#  away_team_name            :string
#  away_team_score           :integer          default(0)
#  completion                :string
#  description               :text
#  duration                  :integer
#  ends_on                   :datetime
#  exclude_from_team_records :boolean
#  home_team_custom_name     :boolean
#  home_team_name            :string
#  home_team_score           :integer          default(0)
#  private                   :boolean          default(FALSE), not null
#  result                    :string
#  starts_on                 :datetime
#  statsheet_type            :string
#  summary                   :string
#  text_after                :string
#  text_before               :string
#  type                      :string
#  created_at                :datetime
#  updated_at                :datetime
#  away_team_id              :integer
#  away_team_locker_room_id  :integer
#  division_id               :integer
#  home_team_id              :integer
#  home_team_locker_room_id  :integer
#  location_id               :integer
#  page_id                   :integer
#  playing_surface_id        :integer
#  program_id                :integer
#  season_id                 :integer
#  statsheet_id              :integer
#  tenant_id                 :integer
#
# Indexes
#
#  index_events_on_away_team_id              (away_team_id)
#  index_events_on_away_team_locker_room_id  (away_team_locker_room_id)
#  index_events_on_division_id               (division_id)
#  index_events_on_home_team_id              (home_team_id)
#  index_events_on_home_team_locker_room_id  (home_team_locker_room_id)
#  index_events_on_location_id               (location_id)
#  index_events_on_page_id                   (page_id)
#  index_events_on_playing_surface_id        (playing_surface_id)
#  index_events_on_program_id                (program_id)
#  index_events_on_season_id                 (season_id)
#  index_events_on_tenant_id                 (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (page_id => pages.id)
#  fk_rails_...  (program_id => programs.id)
#
class Event < ActiveRecord::Base
  include Sportified::TenantScoped
  acts_as_ordered_taggable
  audited

  belongs_to :program, required: false

  belongs_to :page, required: false
  
  belongs_to :location
  validates_presence_of :location_id

  belongs_to :home_team_locker_room, class_name: 'LockerRoom', required: false
  belongs_to :away_team_locker_room, class_name: 'LockerRoom', required: false

  has_one :product, as: :registrable

  alias_attribute :starts_at, :starts_on

  validates_presence_of :starts_on
  # validate :starts_on_cannot_be_in_the_past

  def starts_on_cannot_be_in_the_past
    if new_record? && starts_on.past?
      errors.add(:starts_on, "can't be in the past")
    end
  end

  before_save :set_starts_on
  def set_starts_on
    self.starts_on = starts_on.beginning_of_day if all_day
  end

  validates_presence_of :duration
  validates_numericality_of :duration, :only_integer => true

  before_save :set_duration
  def set_duration
    self.duration = (24 * 60) if all_day
  end

  before_save :set_ends_on
  def set_ends_on
    self.ends_on = self.starts_on.advance(:minutes => self.duration)
  end

  scope :in_the_past, ->{ where('starts_on < ?', DateTime.now) }
  scope :in_the_future, ->{ where('starts_on > ?', DateTime.now) }
  scope :after, ->(after) { where('starts_on > ?', after) }
  scope :ends_after, ->(after) { where('ends_on > ?', after) }
  scope :before, ->(before) { where('starts_on < ?', before) }
  scope :public_only, ->{ where(private: false) }
  scope :with_product, ->{ joins(:product).where('products.registrable_type = \'Event\' AND products.id IS NOT NULL') }

  def start_time
    self.starts_on
  end

  def module_name
    self.class.name.deconstantize.underscore.presence
  end

  def color_key
    raise "color_key must be implemented by subclass #{self.class.name}"
  end

end
