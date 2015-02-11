class League < ActiveRecord::Base
  include Sportified::TenantScoped 
  
  validates :name, presence: true  
  
  has_and_belongs_to_many :seasons
  has_many :teams
  #has_many :events  

 before_save do |league|
   league.slug = league.name.parameterize    
 end
 
 scope :with_slug, ->(slug) { where(:slug => slug) }

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

 #after_save do |league|
 #  league.teams.each do |team|
 #    team.set_league_name_and_slug league
 #    team.save
 #  end if league.name_changed?
 #end
 
 def apply_mongo_season_ids!(season_ids)
 end

end
