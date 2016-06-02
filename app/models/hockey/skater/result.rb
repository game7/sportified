# == Schema Information
#
# Table name: hockey_skaters
#
#  id                        :integer          not null, primary key
#  type                      :string
#  tenant_id                 :integer
#  team_id                   :integer
#  player_id                 :integer
#  statsheet_id              :integer
#  jersey_number             :string
#  games_played              :integer          default(0)
#  goals                     :integer          default(0)
#  assists                   :integer          default(0)
#  points                    :integer          default(0)
#  penalties                 :integer          default(0)
#  penalty_minutes           :integer          default(0)
#  minor_penalties           :integer          default(0)
#  major_penalties           :integer          default(0)
#  misconduct_penalties      :integer          default(0)
#  game_misconduct_penalties :integer          default(0)
#  hat_tricks                :integer          default(0)
#  playmakers                :integer          default(0)
#  gordie_howes              :integer          default(0)
#  ejections                 :integer          default(0)
#  mongo_id                  :string
#  created_at                :datetime
#  updated_at                :datetime
#  first_name                :string
#  last_name                 :string
#

class Hockey::Skater::Result < Hockey::Skater

  belongs_to :statsheet, class_name: 'Hockey::Statsheet'
  has_one :game, through: :statsheet, class_name: 'League::Game'
  belongs_to :team, class_name: 'League::Team'

  validates :statsheet, presence: true
  validates :team, presence: true

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

  private

  def calculate_points
    self.points = self.goals + self.assists
  end

  def calculate_hat_tricks
    self.hat_tricks = ( self.goals / 3 )
  end

  def calculate_playmakers
    self.playmakers = ( self.assists / 3 )
  end

  def calculate_gordie_howes
    self.gordie_howes = ( self.goals >= 1 and self.assists >= 1 and self.penalties >= 1 ? 1 : 0 )
  end

end
