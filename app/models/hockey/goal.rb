# == Schema Information
#
# Table name: hockey_goals
#
#  id                      :integer          not null, primary key
#  tenant_id               :integer
#  statsheet_id            :integer
#  period                  :integer
#  minute                  :integer
#  second                  :integer
#  team_id                 :integer
#  scored_by_id            :integer
#  scored_on_id            :integer
#  assisted_by_id          :integer
#  also_assisted_by_id     :integer
#  strength                :string(255)
#  mongo_id                :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  scored_by_number        :string(255)
#  assisted_by_number      :string(255)
#  also_assisted_by_number :string(255)
#

class Hockey::Goal < ActiveRecord::Base
  include Sportified::TenantScoped

  STR = %w[5-5 5-4 5-3 4-5 4-4 4-3 3-5 3-4 3-3 6-5 6-4 6-3]

  validates :period, presence: true

  validates :minute, presence: true
  validates :minute, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 90 }

  validates :second, presence: true
  validates :second, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 60 }

  belongs_to :statsheet, class_name: 'Hockey::Statsheet'
  belongs_to :team, class_name: "Team"
  belongs_to :scored_by, class_name: "Hockey::Skater::Result"
  belongs_to :scored_on, class_name: "Hockey::Goaltender::Result"
  belongs_to :assisted_by, class_name: "Hockey::Skater::Result"
  belongs_to :also_assisted_by, class_name: "Hockey::Skater::Result"

  scope :sorted_by_time, ->{ order(period: :asc, minute: :desc, second: :desc) }
  scope :for_period, ->(period) { where(per: period) }

  def apply_mongo!(mongo)
    self.team = (mongo[:side] == 'home' ? self.statsheet.home_team : self.statsheet.away_team)
    opponent = (mongo[:side] == 'home' ? self.statsheet.away_team : self.statsheet.home_team)

    self.tenant_id = self.team.tenant_id if self.team

    self.scored_by_number = mongo[:plr]
    self.scored_by = self.statsheet.skaters.where(team_id: self.team_id).where(jersey_number: mongo[:plr]).first if self.team

    unless mongo[:a1].blank?
      self.assisted_by_number = mongo[:a1]
      self.assisted_by = self.statsheet.skaters.where(team_id: self.team_id).where(jersey_number: mongo[:a1]).first if self.team
    end

    unless mongo[:a2].blank?
      self.also_assisted_by_number = mongo[:a2]
      self.also_assisted_by = self.statsheet.skaters.where(team_id: self.team_id).where(jersey_number: mongo[:a2]).first if self.team
    end

    self.scored_on = self.statsheet.goaltenders.where(team_id: opponent.id).first

    self.strength = mongo[:str]
    self.tenant_id = self.statsheet.tenant_id
    self.period = mongo[:per]
    self.minute = mongo[:min]
    self.second = mongo[:sec]
  end

  class << self
    def strengths
      STR
    end
  end

  def time
    format_time(self.minute, self.second)
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
