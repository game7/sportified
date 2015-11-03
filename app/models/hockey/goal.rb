class Hockey::Goal < ActiveRecord::Base
  include Sportified::TenantScoped
  
  STR = %w[5-5 5-4 5-3 4-5 4-4 4-3 3-5 3-4 3-3 6-5 6-4 6-3]

  belongs_to :statsheet, class_name: 'Hockey::Statsheet'
  belongs_to :team, class_name: "Team"
  belongs_to :scored_by, class_name: "Hockey::Skater::Result"
  belongs_to :scored_on, class_name: "Hockey::Goaltender::Result"
  belongs_to :assisted_by, class_name: "Hockey::Skater::Result"
  belongs_to :also_assisted_by, class_name: "Hockey::Skater::Result"
  
  scope :sorted_by_time, ->{ order(period: :asc, minute: :desc, second: :desc) }
  scope :for_period, ->(period) { where(per: period) }  

  def apply_mongo!(mongo)
    self.team = (mongo['side'] == 'home' ? self.statsheet.home_team : self.statsheet.away_team)
    opponent = (mongo['side'] == 'home' ? self.statsheet.away_team : self.statsheet.home_team)
    
    self.tenant_id = self.team.tenant_id if self.team
    
    self.scored_by_number = mongo['plr']
    player = self.team.players.where(jersey_number: mongo['plr']).first if self.team
    self.scored_by = self.statsheet.skaters.where(player_id: player.id).first if player
    
    self.assisted_by_number = mongo['a1']
    player = self.team.players.where(jersey_number: mongo['a1']).first if self.team
    self.assisted_by = self.statsheet.skaters.where(player_id: player.id).first if player
    
    self.assisted_by_number = mongo['a2']
    player = self.team.players.where(jersey_number: mongo['a2']).first if self.team
    self.also_assisted_by = self.statsheet.skaters.where(player_id: player.id).first if player
    
    player = self.statsheet.goaltenders.joins(:player).where('players.team_id' => opponent.id).first if opponent
    self.scored_on = player
    
    self.strength = mongo['str']
    self.tenant_id = self.statsheet.tenant_id
    self.period = mongo['per']
    self.minute = mongo['min']
    self.second = mongo['sec']
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
