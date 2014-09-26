class League
  include Mongoid::Document
  include Sportified::TenantScoped
  
  field :name, :type => String
  validates :name, presence: true
  
  field :slug, :type => String
  
  field :show_standings, :type => Boolean, :default => true
  field :show_players, :type => Boolean, :default => true
  field :show_statistics, :type => Boolean, :default => true
  
  has_and_belongs_to_many :seasons
  has_many :teams
  has_many :events
  
  before_save do |league|
    league.slug = league.name.parameterize    
  end
  
  scope :with_slug, lambda { |slug| where(:slug => slug) }
  
  field :standings_array, :type => Array, :default => %w{gp w rl sol pts scored allowed margin stk}
  
  def self.standings_separator
    "|"
  end
  
  def standings
    (standings_array || []).join(self.class.standings_separator)
  end
  
  def standings=(standings)
    self.standings_array = standings.split(self.class.standings_separator).map(&:strip).reject(&:blank?)
  end
  
  
  class << self
    def for_season(season)
      season_id = ( season.class == Season ? season.id : season )
      where(:season_ids => season_id)
    end
  end  
  
end
