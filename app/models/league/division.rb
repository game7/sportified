class League::Division < ActiveRecord::Base
  include Sportified::TenantScoped

  validates :name, presence: true

  belongs_to :program
  has_and_belongs_to_many :seasons, class_name: '::Season', join_table: 'divisions_seasons'
  has_many :teams, class_name: '::Team'
  has_many :events, class_name: '::Event'

 before_save do |division|
   division.slug = division.name.parameterize
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

 def standings_schema_id
   read_attribute(:standings_schema_id) || 'pct'
 end

 def standings_schema
   League::Division.standings_schemata[self.standings_schema_id] || Division.standings_schemata['pct']
 end

 def self.standings_schema_options
   self.standings_schemata.collect do |s|
     [ s[1]['description'], s[0] ]
   end
 end

 def self.standings_schemata
   @@schemata ||= YAML.load_file(Rails.root.to_s + '/config/standings.yml')
 end

 class << self
   def for_season(season)
     season_id = ( season.class == Season ? season.id : season )
     where(:season_ids => season_id)
   end
 end
end
