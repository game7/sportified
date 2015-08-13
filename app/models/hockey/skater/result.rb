class Hockey::Skater::Result < Hockey::Skater
  after_touch :calculate_statistics
  
  belongs_to :statsheet, class_name: 'Hockey::Statsheet'
  has_one :game, through: :statsheet
  belongs_to :team
  
  validates :statsheet, presence: true
  validates :team, presence: true
  
  default_scope { includes(:player) }
  
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
    
  def apply_mongo_player_id!(mongo)
    self.player = ::Player.where(:mongo_id => mongo.to_s).first
  end
  
  def apply_mongo!(mongo)
    self.tenant_id = self.statsheet.tenant_id
    self.team = mongo['side'] == 'home' ? self.statsheet.home_team : self.statsheet.away_team
    self.jersey_number = mongo['num']   
    self.games_played = mongo['gp']
    self.goals = mongo['g']
    self.assists = mongo['a']
    self.points = mongo['pts']
    self.penalties = mongo['pen']
    self.penalty_minutes = mongo['pim']
    self.minor_penalties = mongo['pen_minor']
    self.major_penalties = mongo['pen_major']
    self.misconduct_penalties = mongo['pen_misc']
    self.game_misconduct_penalties = mongo['pen_game']
    self.ejections = mongo['eject']
    self.hat_tricks = mongo['hat']
    self.playmakers = mongo['plmkr']
    self.gordie_howes = mongo['gordie']
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
