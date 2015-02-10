class Team < ActiveRecord::Base
  include Sportified::TenantScoped
  include Concerns::Brandable
  
  belongs_to :tenant
  belongs_to :league
  belongs_to :season
  belongs_to :club
  
  validates_presence_of :name, :league_id, :season_id

  #has_many :players  
  #embeds_one :record, :class_name => "Team::Record"

  before_save :set_slug
  def set_slug
    self.slug = self.name.parameterize
  end

  before_save :ensure_short_name
  def ensure_short_name
    if self.short_name.nil? || self.short_name.empty?
      self.short_name = self.name
    end
  end
  
  before_save :ensure_record
  def ensure_record
    #self.record ||= Team::Record.new
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

  scope :with_slug, ->(slug) { where(:slug => slug) }
  
  def apply_mongo_season_id! season_id
    self.season = Season.where(:mongo_id => season_id.to_s).first
  end
  
  def apply_mongo_league_id! league_id
    self.league = League.where(:mongo_id => league_id.to_s).first
  end

  def apply_mongo_club_id! club_id
    self.club = Club.where(:mongo_id => club_id.to_s).first if club_id
  end
  
end
