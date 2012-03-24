class Player
  include Mongoid::Document
  before_validation :set_league_and_season
  
  field :first_name
  field :last_name
  field :jersey_number
  field :birthdate, type: Date
  field :email

  field :slug

  belongs_to :team
  validates :team_id, presence: true
  
  belongs_to :league
  validates :league_id, presence: true
  
  belongs_to :season
  validates :season_id, presence: true  
  
  embeds_one :record, :class_name => "Hockey::Player::Record"
  before_save :ensure_record

  before_save :set_slug

  def full_name
    [first_name, last_name].join(' ')
  end
  
  def age
    ((Date.today - birthdate) / 365).floor if birthdate
  end
  
  class << self
    def for_league(league)
      league_id = ( league.class == League ? league.id : league )
      where(:league_id => league_id)      
    end
    def for_season(season)
      season_id = ( season.class == Season ? season.id : season )
      where(:season_id => season_id)
    end
  end  
   

  private

    def set_slug
      self.slug = full_name.parameterize
    end
    
    def ensure_record
      self.record ||= Hockey::Player::Record.new
    end
    
    def set_league_and_season
      self.league_id = team.league_id if team
      self.season_id = team.season_id if team
    end

end
