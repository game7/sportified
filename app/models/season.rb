class Season
  include Mongoid::Document
  include Sportified::TenantScoped
 
  field :name  
  field :slug
  field :starts_on, :type => Date

  has_and_belongs_to_many :leagues
  has_many :divisions
  has_many :teams
  has_many :events

  validates_presence_of :name, :starts_on

  class << self
    def most_recent
      where(:starts_on.lt => DateTime.now).desc(:starts_on).first
    end
    def latest
      desc(:starts_on).first
    end
  end

  scope :with_name, ->(name) { where(:name => name) }
  scope :with_slug, ->(slug) { where(:slug => slug) }

  before_save do |season|
    season.slug = season.name.parameterize    
  end
  
  after_save do |season|
    season.teams.each do |team|
      team.set_season_name_and_slug season
      team.save
    end if season.name_changed?
  end  


end
