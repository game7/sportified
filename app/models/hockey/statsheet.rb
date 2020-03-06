# == Schema Information
#
# Table name: hockey_statsheets
#
#  id            :integer          not null, primary key
#  tenant_id     :integer
#  posted        :boolean
#  away_score    :integer
#  home_score    :integer
#  latest_period :string
#  latest_minute :integer
#  latest_second :integer
#  min_1         :integer
#  min_2         :integer
#  min_3         :integer
#  min_ot        :integer
#  away_shots_1  :integer
#  away_shots_2  :integer
#  away_shots_3  :integer
#  away_shots_ot :integer
#  home_shots_1  :integer
#  home_shots_2  :integer
#  home_shots_3  :integer
#  home_shots_ot :integer
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_hockey_statsheets_on_tenant_id  (tenant_id)
#

class Hockey::Statsheet < ActiveRecord::Base
  include Sportified::TenantScoped

  has_one :game, :as => :statsheet, :class_name => '::League::Game'
  validates_presence_of :game

  has_one :home_team, through: :game
  has_one :away_team, through: :game

  has_many :skaters, class_name: 'Hockey::Skater::Result' do
    def home
      where("hockey_skaters.team_id = ?", proxy_association.owner.game.home_team_id)
    end
    def away
      where("hockey_skaters.team_id = ?", proxy_association.owner.game.away_team_id)
    end
    def for_side(side)
      owner = proxy_association.owner
      id = (side == 'home' ? owner.game.home_team_id : owner.game.away_team_id)
      self.for_team(id)
    end
    def for_team(team_id)
      where("hockey_skaters.team_id = ?", team_id)
    end
    def playing
      where("games_played = ?", 1)
    end
  end

  has_many :goaltenders, class_name: 'Hockey::Goaltender::Result' do
    def for_side(side)
      owner = proxy_association.owner
      id = (side == 'home' ? owner.game.home_team_id : owner.game.away_team_id)
      where("hockey_goaltenders.team_id = ?", id)
    end
  end


  has_many :goals, class_name: 'Hockey::Goal' do
    def for_period(period)
      where('period = ?', period)
    end
    def period1
      where('period = ?', '1')
    end
    def period2
      where('period = ?', '2')
    end
    def period3
      where('period = ?', '3')
    end
    def overtime
      where('period = ?', 'OT')
    end
    def home
      where("hockey_goals.team_id = ?", proxy_association.owner.game.home_team_id)
    end
    def away
      where("hockey_goals.team_id = ?", proxy_association.owner.game.away_team_id)
    end
    def grouped_by_period
      periods = {}
      %w{1 2 3 ot all}.each{|i| periods[i] = []}
      puts '---------------------------------------------------'
      puts periods
      puts '---------------------------------------------------'
      all.each do |goal|
        puts goal.period
        periods[goal.period.to_s] << goal
        periods['all'] << goal
      end
      periods
    end
  end

  has_many :penalties, class_name: 'Hockey::Penalty' do
    def for_period(period)
      where('period = ?', period)
    end
    def home
      where("hockey_penalties.team_id = ?", proxy_association.owner.game.home_team_id)
    end
    def away
      where("hockey_penalties.team_id = ?", proxy_association.owner.game.away_team_id)
    end
  end

  def teams
    [ away_team, home_team ]
  end

  def min_total
    min_1.to_i + min_2.to_i + min_3.to_i + min_ot.to_i
  end

  def completed_in
    min_ot > 0 ? 'overtime' : 'regulation'
  end

  def away_shots_total
    away_shots_1.to_i + away_shots_2.to_i + away_shots_3.to_i + away_shots_ot.to_i
  end
  def home_shots_total
    home_shots_1.to_i + home_shots_2.to_i + home_shots_3.to_i + home_shots_ot.to_i
  end

  def clear_shots
    ['away', 'home'].each do |side|
      ['1','2','3','ot'].each do |per|
        self["#{side}_shots_#{per}"] = 0
      end
    end
  end

  def away_pim_total
    penalties.away.sum(:dur) || 0
  end
  def home_pim_total
    penalties.home.sum(:dur) || 0
  end

  def overtime?
    min_ot && min_ot > 0
  end

  def shootout?
    false
  end

  def post
    Hockey::Statsheet::Processor.post self
  end

  def unpost
    Hockey::Statsheet::Processor.unpost self
  end

  def load_players(game = self.game)
    load_team_players(game.away_team) if game.away_team
    load_team_players(game.home_team) if game.home_team
  end

  def load_team_players(team)
    skater_ids = self.skaters.where("team_id = ?", team.id).collect{ |plr| plr.player_id }
    team.players.each do |player|
      skaters.create(
        team:           team,
        player:         player,
        first_name:     player.first_name,
        last_name:      player.last_name,
        jersey_number:  player.jersey_number,
        games_played:   1
      ) unless skater_ids.index(player.id)
    end if team
  end

  def autoload_goaltenders

    goaltenders.build(team_id:        game.home_team_id,
                      minutes_played: min_total,
                      shots_against:  away_shots_total,
                      goals_against:  goals.away.count)

    goaltenders.build(team_id:        game.away_team_id,
                      minutes_played: min_total,
                      shots_against:  home_shots_total,
                      goals_against:  goals.home.count)

  end

end
