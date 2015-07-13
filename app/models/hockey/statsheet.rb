class Hockey::Statsheet < ActiveRecord::Base
  include Sportified::TenantScoped
  
  has_one :game, :as => :statsheet
  validates_presence_of :game
  
  has_one :home_team, through: :game
  has_one :away_team, through: :game
    
  has_many :skaters, class_name: 'Hockey::Skater::Result' do
    def home
      where("hockey_skaters.team_id = ?", proxy_association.owner.home_team.id)
    end
    def away
      where("hockey_skaters.team_id = ?", proxy_association.owner.away_team.id)
    end
  end
  
  has_many :goaltenders, class_name: 'Hockey::Goaltender::Result'
  
  has_many :goals, class_name: 'Hockey::Goal' do
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
      where('period = ?' 'OT')
    end
    def home
      where("hockey_goals.team_id = ?", proxy_association.owner.home_team.id)
    end
    def away
      where("hockey_goals.team_id = ?", proxy_association.owner.away_team.id)
    end
  end
  
  has_many :penalties, class_name: 'Hockey::Penalty'
  
  def teams
    [ away_team, home_team ]
  end
  
  def min_total
    #min_1 + min_2 + min_3 + min_ot
    'boo'
  end
  
  def completed_in
    min_ot > 0 ? 'overtime' : 'regulation'
  end
  
  def away_shots_total
    #away_shots_1 + away_shots_2 + away_shots_3 + away_shots_ot
    0
  end
  def home_shots_total
    #home_shots_1 + home_shots_2 + home_shots_3 + home_shots_ot
    0
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
    min_ot > 0
  end

  def shootout?
    false
  end

  def load_players(game = self.game)
    load_team_players(game.away_team)
    load_team_players(game.home_team)    
  end

  def load_team_players(team)
    skater_ids = self.skaters.where("team_id = ?", team.id).collect{ |plr| plr.player_id }
    team.players.each do |player|
      skaters.create(team: team, player: player) unless skater_ids.index(player.id)
    end if team
  end
  
  def apply_mongo_goaltenders!(mongo_goaltenders)

  end
  
  def apply_mongo_players!(mongo_goaltenders)

  end
  
  def apply_mongo_game_id!(mongo_game)
    self.game = Game.where(:mongo_id => mongo_game.to_s).first
  end
  
  def apply_mongo!(mongo)
    self.tenant = self.game.tenant    
  end
  
end
