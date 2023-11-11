# == Schema Information
#
# Table name: hockey_penalties
#
#  id                  :integer          not null, primary key
#  committed_by_number :string
#  duration            :integer
#  end_minute          :integer
#  end_period          :string
#  end_second          :integer
#  infraction          :string
#  minute              :integer
#  period              :string
#  second              :integer
#  severity            :string
#  start_minute        :integer
#  start_period        :string
#  start_second        :integer
#  created_at          :datetime
#  updated_at          :datetime
#  committed_by_id     :integer
#  statsheet_id        :integer
#  team_id             :integer
#  tenant_id           :integer
#
# Indexes
#
#  index_hockey_penalties_on_statsheet_id  (statsheet_id)
#  index_hockey_penalties_on_tenant_id     (tenant_id)
#
class Hockey::Penalty < ActiveRecord::Base
  include Sportified::TenantScoped

  PERIODS = %w[1 2 3 OT].freeze
  SEVERITIES = %w[minor major misconduct game_misconduct match].freeze
  INFRACTIONS = %w[butt_ending checking_from_behind cross-checking delay_of_game elbowing
                   boardning fighting holding hooking interference kneeing roughing slashing
                   spearing tripping unsportsmanlike_conduct misconduct game_misconduct
                   too_many_men high_stick bench_minor head_contact].freeze

  belongs_to :statsheet, class_name: 'Hockey::Statsheet'
  belongs_to :team, class_name: '::League::Team'
  belongs_to :committed_by, class_name: 'Hockey::Skater::Result'

  validates :period, presence: true, inclusion: { in: PERIODS }
  validates :minute, presence: true,
                     numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 20 }
  validates :second, presence: true,
                     numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59 }
  validates :infraction, presence: true
  validates :duration, presence: true,
                       numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 20 }
  validates :severity, presence: true
  validates :start_minute,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 20 }, allow_nil: true
  validates :start_second,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59 }, allow_nil: true
  validates :end_minute, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 20 },
                         allow_nil: true
  validates :end_second, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59 },
                         allow_nil: true

  class << self
    def severities
      SEVERITIES.collect { |i| i.humanize }
    end

    def infractions
      INFRACTIONS.collect { |i| i.humanize }
    end
  end

  def start_time
    format_time(start_min, start_sec)
  end

  def end_time
    format_time(end_min, end_sec)
  end

  scope :sorted_by_time, -> { order(period: :asc, minute: :desc, second: :desc) }
  scope :for_period, ->(period) { where(per: period) }

  def apply_mongo!(mongo)
    self.team = (mongo['side'] == 'home' ? statsheet.home_team : statsheet.away_team)
    self.tenant_id = team.tenant_id if team
    self.committed_by_number = mongo['plr']
    self.committed_by = statsheet.skaters.where(team_id: team_id).where(jersey_number: mongo[:plr]).first if team
    self.tenant_id = statsheet.tenant_id
    self.infraction = mongo['inf']
    self.duration = mongo['dur']
    self.period = mongo['per']
    self.minute = mongo['min']
    self.second = mongo['sec']
    self.start_period = mongo['start_per']
    self.start_minute = mongo['start_min']
    self.start_second = mongo['start_sec']
    self.end_period = mongo['end_per']
    self.end_minute = mongo['end_min']
    self.end_second = mongo['end_sec']
  end

  def time
    format_time(minute, second)
  end

  def start_time
    format_time(start_minute, start_second)
  end

  def end_time
    format_time(end_minute, end_second)
  end

  PER = %w[1 2 3 OT]

  class << self
    def periods
      PER
    end
  end

  protected

  def format_time(min, sec)
    min.to_s + ':' + "0#{sec}"[-2, 2] unless min.blank? || sec.blank?
  end
end
