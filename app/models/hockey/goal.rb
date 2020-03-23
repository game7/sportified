# == Schema Information
#
# Table name: hockey_goals
#
#  id                      :integer          not null, primary key
#  tenant_id               :integer
#  statsheet_id            :integer
#  period                  :string
#  minute                  :integer
#  second                  :integer
#  team_id                 :integer
#  scored_by_id            :integer
#  scored_on_id            :integer
#  assisted_by_id          :integer
#  also_assisted_by_id     :integer
#  strength                :string
#  created_at              :datetime
#  updated_at              :datetime
#  scored_by_number        :string
#  assisted_by_number      :string
#  also_assisted_by_number :string
#
# Indexes
#
#  index_hockey_goals_on_statsheet_id  (statsheet_id)
#  index_hockey_goals_on_tenant_id     (tenant_id)
#

class Hockey::Goal < ActiveRecord::Base
  include Sportified::TenantScoped

  STR = %w[5-5 5-4 5-3 4-5 4-4 4-3 3-5 3-4 3-3 6-5 6-4 6-3]

  validates :statsheet, presence: true
  validates :team, presence: true
  validates :scored_by, presence: true

  validates :period, presence: true

  validates :minute, presence: true
  validates :minute, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 90 }

  validates :second, presence: true
  validates :second, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 60 }

  belongs_to :statsheet, class_name: 'Hockey::Statsheet'
  belongs_to :team, class_name: "::League::Team"
  belongs_to :scored_by, class_name: "Hockey::Skater::Result"
  belongs_to :scored_on, class_name: "Hockey::Goaltender::Result", required: false
  belongs_to :assisted_by, class_name: "Hockey::Skater::Result", required: false
  belongs_to :also_assisted_by, class_name: "Hockey::Skater::Result", required: false

  scope :sorted_by_time, ->{ order(period: :asc, minute: :desc, second: :desc) }
  scope :for_period, ->(period) { where(per: period) }

  before_save :downcase_period
  def downcase_period
    self.period = self.period.downcase
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
