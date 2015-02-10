class Season < ActiveRecord::Base
  include Sportified::TenantScoped 
  
  validates_presence_of :name, :starts_on
  
  has_and_belongs_to_many :leagues
  #has_many :divisions
  #has_many :teams
  #has_many :events  

  class << self
    def most_recent
      where("starts_on < ? ", DateTime.now).order(starts_on: :desc).first
    end
    def latest
      order(starts_on: :desc).first
    end
  end

  scope :with_name, ->(name) { where(:name => name) }
  scope :with_slug, ->(slug) { where(:slug => slug) }

  before_save do |season|
    season.slug = season.name.parameterize    
  end
  
  #after_save do |season|
  #  season.teams.each do |team|
  #    team.set_season_name_and_slug season
  #    team.save
  #  end if season.name_changed?
  #end
  
  def apply_mongo_league_ids!(league_ids)
  end  
  
end
