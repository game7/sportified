# == Schema Information
#
# Table name: hockey_penalties
#
#  id                  :integer          not null, primary key
#  tenant_id           :integer
#  statsheet_id        :integer
#  period              :integer
#  minute              :integer
#  second              :integer
#  team_id             :integer
#  committed_by_id     :integer
#  infraction          :string
#  duration            :integer
#  severity            :string
#  start_period        :string
#  start_minute        :integer
#  start_second        :integer
#  end_period          :string
#  end_minute          :integer
#  end_second          :integer
#  created_at          :datetime
#  updated_at          :datetime
#  committed_by_number :string
#
# Indexes
#
#  index_hockey_penalties_on_statsheet_id  (statsheet_id)
#  index_hockey_penalties_on_tenant_id     (tenant_id)
#

class Hockey::Penalty < ActiveRecord::Base
  include Sportified::TenantScoped

  SEVERITIES = %w[minor major misconduct game_misconduct match]
  INFRACTIONS = %w[butt_ending checking_from_behind cross-checking delay_of_game elbowing
                  fighting holding hooking interference kneeing roughing slashing
                  spearing tripping unsportsmanlike_conduct misconduct game_misconduct
                  too_many_men high_stick bench_minor]

  belongs_to :statsheet, class_name: 'Hockey::Statsheet'
  belongs_to :team, class_name: '::League::Team'
  belongs_to :committed_by, class_name: 'Hockey::Skater::Result'

  validates :period, presence: true
  validates :minute, presence: true, numericality: { only_integer: true }
  validates :second, presence: true, numericality: { only_integer: true }
  validates :infraction, presence: true
  validates :duration, presence: true, numericality: true
  validates :severity, presence: true
  validates :start_minute, numericality: { only_integer: true }, allow_nil: true
  validates :start_second, numericality: { only_integer: true }, allow_nil: true
  validates :end_minute, numericality: { only_integer: true }, allow_nil: true
  validates :end_second, numericality: { only_integer: true }, allow_nil: true

  class << self
    def severities
      SEVERITIES.collect{|i| i.humanize}
    end
    def infractions
      INFRACTIONS.collect{|i| i.humanize}
    end
  end

  def start_time
    format_time(self.start_min, self.start_sec)
  end

  def end_time
    format_time(self.end_min, self.end_sec)
  end

  scope :sorted_by_time, ->{ order(period: :asc, minute: :desc, second: :desc) }
  scope :for_period, ->(period) { where(per: period) }

  def apply_mongo!(mongo)
    self.team = (mongo['side'] == 'home' ? self.statsheet.home_team : self.statsheet.away_team)
    self.tenant_id = self.team.tenant_id if self.team
    self.committed_by_number = mongo['plr']
    self.committed_by = self.statsheet.skaters.where(team_id: self.team_id).where(jersey_number: mongo[:plr]).first if self.team
    self.tenant_id = self.statsheet.tenant_id
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
    format_time(self.minute, self.second)
  end

  def start_time
    format_time(self.start_minute, self.start_second)
  end

  def end_time
    format_time(self.end_minute, self.end_second)
  end

  PER = %w[1 2 3 OT]

  class << self
    def periods
      PER
    end
  end

  protected

    def format_time(min, sec)
      min.to_s + ':' + "0#{sec.to_s}"[-2,2] unless min.blank? || sec.blank?
    end

end
