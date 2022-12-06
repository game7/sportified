# == Schema Information
#
# Table name: hockey_skaters
#
#  id                        :integer          not null, primary key
#  assists                   :integer          default(0)
#  ejections                 :integer          default(0)
#  first_name                :string
#  game_misconduct_penalties :integer          default(0)
#  games_played              :integer          default(0)
#  goals                     :integer          default(0)
#  gordie_howes              :integer          default(0)
#  hat_tricks                :integer          default(0)
#  jersey_number             :string
#  last_name                 :string
#  major_penalties           :integer          default(0)
#  minor_penalties           :integer          default(0)
#  misconduct_penalties      :integer          default(0)
#  penalties                 :integer          default(0)
#  penalty_minutes           :integer          default(0)
#  playmakers                :integer          default(0)
#  points                    :integer          default(0)
#  type                      :string
#  created_at                :datetime
#  updated_at                :datetime
#  player_id                 :integer
#  statsheet_id              :integer
#  team_id                   :integer
#  tenant_id                 :integer
#
# Indexes
#
#  index_hockey_skaters_on_player_id     (player_id)
#  index_hockey_skaters_on_statsheet_id  (statsheet_id)
#  index_hockey_skaters_on_team_id       (team_id)
#  index_hockey_skaters_on_tenant_id     (tenant_id)
#
class Hockey::Skater::Result < Hockey::Skater
  default_scope { where(type: klass.name) }

  belongs_to :statsheet, class_name: 'Hockey::Statsheet'
  has_one :game, through: :statsheet, class_name: 'League::Game'
  belongs_to :team, class_name: 'League::Team'

  validates :statsheet, presence: true
  validates :team, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  default_scope { includes(:player) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def goals=(value)
    write_attribute(:goals, value)
    calculate_points
    calculate_hat_tricks
    calculate_gordie_howes
  end

  def assists=(value)
    write_attribute(:assists, value)
    calculate_points
    calculate_playmakers
    calculate_gordie_howes
  end

  def penalties=(value)
    write_attribute(:penalties, value)
    calculate_gordie_howes
  end

  def recalculate_penalty_types
    self.penalty_minutes = 0
    self.minor_penalties = 0
    self.major_penalties = 0
    self.misconduct_penalties = 0
    self.game_misconduct_penalties = 0
    ::Hockey::Penalty.where(committed_by: self).find_each do |penalty|
      self.penalty_minutes           += penalty.duration
      self.minor_penalties           += 1 if penalty.severity == 'Minor'
      self.major_penalties           += 1 if penalty.severity == 'Major'
      self.misconduct_penalties      += 1 if penalty.severity == 'Misconduct'
      self.game_misconduct_penalties += 1 if penalty.severity == 'Game misconduct'
    end
  end

  def recalculate_penalty_types!
    recalculate_penalty_types
    save
  end

  private

  def calculate_points
    self.points = goals + assists
  end

  def calculate_hat_tricks
    self.hat_tricks = (goals / 3)
  end

  def calculate_playmakers
    self.playmakers = (assists / 3)
  end

  def calculate_gordie_howes
    self.gordie_howes = (goals >= 1 and assists >= 1 and penalties >= 1 ? 1 : 0)
  end
end
