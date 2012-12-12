class Division
  include Mongoid::Document
  include Sportified::TenantScoped
 
  field :name

  belongs_to :season
  belongs_to :league

  has_many :teams

  validates :name, presence: true
  validates :league_id, presence: true

  scope :with_name, lambda { |name| where(:name => name) }
  
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

end
