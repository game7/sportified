# == Schema Information
#
# Table name: hockey_goaltenders
#
#  id                       :integer          not null, primary key
#  type                     :string
#  tenant_id                :integer
#  team_id                  :integer
#  player_id                :integer
#  statsheet_id             :integer
#  games_played             :integer          default(0)
#  minutes_played           :integer          default(0)
#  shots_against            :integer          default(0)
#  goals_against            :integer          default(0)
#  saves                    :integer          default(0)
#  save_percentage          :float            default(0.0)
#  goals_against_average    :float            default(0.0)
#  shutouts                 :integer          default(0)
#  shootout_attempts        :integer          default(0)
#  shootout_goals           :integer          default(0)
#  shootout_save_percentage :float            default(0.0)
#  regulation_wins          :integer          default(0)
#  regulation_losses        :integer          default(0)
#  overtime_wins            :integer          default(0)
#  overtime_losses          :integer          default(0)
#  shootout_wins            :integer          default(0)
#  shootout_losses          :integer          default(0)
#  total_wins               :integer          default(0)
#  total_losses             :integer          default(0)
#  mongo_id                 :string
#  created_at               :datetime
#  updated_at               :datetime
#  jersey_number            :string
#  first_name               :string
#  last_name                :string
#

class Hockey::Goaltender::Result < Hockey::Goaltender

  belongs_to :statsheet, class_name: 'Hockey::Statsheet'
  has_one :game, through: :statsheet, class_name: '::League::Game'
  belongs_to :team, class_name: '::League::Team'

  validates :statsheet, presence: true
  validates :team, presence: true
  #validates :player, presence: true'

  def full_name
    "#{first_name} #{last_name}"
  end

  def apply_mongo_player_id!(mongo)
  end

  def apply_mongo!(mongo)
    self.team_id = self.player.team_id if self.player
    unless self.team_id
      self.team_id = self.statsheet.home_team.id if mongo[:side] == 'home'
      self.team_id = self.statsheet.away_team.id if mongo[:side] == 'away'
    end
    self.player = ::Player.where(:mongo_id => mongo[:player_id].to_s).first
    self.first_name = mongo[:first_name]
    self.last_name = mongo[:last_name]
    self.jersey_number = mongo[:num]
    self.tenant_id = self.statsheet.tenant_id
    self.games_played = mongo[:g_gp]
    self.minutes_played = mongo[:g_toi]
    self.shots_against = mongo[:g_sa]
    self.goals_against = mongo[:g_ga]
    self.saves = mongo[:g_sv]
    self.shutouts = mongo[:g_so]
    self.shootout_attempts = mongo[:g_soa] || 0
    self.shootout_goals = mongo[:s_sog] || 0
    self.shootout_save_percentage = mongo[:sosvp] || 0
    self.regulation_wins = mongo[:g_regw]
    self.regulation_losses = mongo[:g_regl]
    self.overtime_wins = mongo[:g_otw]
    self.overtime_losses = mongo[:g_otl]
    self.shootout_wins = mongo[:g_sow]
    self.shootout_losses = mongo[:g_sol]
    self.total_wins = mongo[:g_totw]
    self.total_losses = mongo[:g_totl]

    self.goals_against_average = (self.goals_against * self.minutes_played) / 45.to_f
    self.save_percentage = self.saves / self.shots_against.to_f
  end
end
