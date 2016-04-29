# == Schema Information
#
# Table name: leagues
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  slug                :string(255)
#  show_standings      :boolean
#  show_players        :boolean
#  show_statistics     :boolean
#  standings_array     :text             default([]), is an Array
#  tenant_id           :integer
#  mongo_id            :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  standings_schema_id :string(255)
#

class League < ActiveRecord::Base
  include Sportified::TenantScoped

  validates :name, presence: true

  has_and_belongs_to_many :seasons
  has_many :teams
  has_many :events

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

 def standings_schema_id
   read_attribute(:standings_schema_id) || 'pct'
 end

 def standings_schema
   League.standings_schemata[self.standings_schema_id] || League.standings_schemata['pct']
 end

 def self.standings_schema_options
   League.standings_schemata.collect do |s|
     [ s[1]['description'], s[0] ]
   end
 end

 def self.standings_schemata
   @@schemata ||= YAML.load_file(Rails.root.to_s + '/config/standings.yml')
 end

 class << self
   def for_season(season)
     season_id = ( season.class == Season ? season.id : season )
     joins(:seasons).where('leagues_seasons.season_id = ?', season_id)
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
