class League
  include Mongoid::Document
  include Sportified::TenantScoped
  
  field :name, :type => String
  validates :name, presence: true
  
  field :slug, :type => String
  
  has_and_belongs_to_many :seasons
  has_many :teams
  has_many :events
  
  before_save do |league|
    league.slug = league.name.parameterize    
  end
  
  scope :with_slug, lambda { |slug| where(:slug => slug) }
  
  class << self
    def for_season(season)
      season_id = ( season.class == Season ? season.id : season )
      where(:season_ids => season_id)
    end
  end  
  
end
