class Game::Import
  include Mongoid::Document
  include Mongoid::Timestamps
  include Sportified::TenantScoped

  field :contents, :type => Array
  validates_presence_of :contents

   belongs_to :season
   field :season_name
   validates_presence_of :season_id
   before_save do |import|
     import.season_name = import.season.name
   end

   belongs_to :division
   field :division_name
   validates_presence_of :division_id
   before_save do |import|
     import.division_name = import.division.name
   end

   field :columns, :type => Array, :default => []

   embeds_many :teams, class_name: 'Map::Team'
   accepts_nested_attributes_for :teams

   embeds_many :venues, class_name: 'Map::Venue'
   accepts_nested_attributes_for :venues

   field :ready, :type => Boolean, :default => false
   field :completed, :type => Boolean, :default => false

   before_create :strip_contents
   def strip_contents
     self.contents.each{|r| r.collect!{|c| c = c.strip } }
   end

   before_create :map_contents
   def map_contents
     map_columns
     map_teams
     map_venues
   end

   before_save :set_readiness
   def set_readiness
     unless completed
       self.ready = ready?
     end
   end

   def can_complete?
     ready
   end

   def ready?
     teams_ready? && venues_ready?
   end

   def teams_ready?
     teams.each{|t| return false unless t.team_id.present?}
     true
   end

   def venues_ready?
     venues.each{|v| return false unless v.venue_id.present?}
     true
   end

   def map_columns
     if contents[0]
       contents[0].each do |col|
         case col
           when 'date'
             self.columns << :date
           when 'time'
             self.columns << :time
           when 'duration'
             self.columns << :duration
           when 'away', 'away_team', 'left', 'left_team'
             self.columns << :away_team
           when 'away_score', 'away_score'
             self.columns << :away_score
           when 'home', 'home_team', 'right', 'right_team'
             self.columns << :home_team
           when 'home_score', 'home_score'
             self.columns << :home_score
           when 'completed_in'
             self.columns << :completed_in
           when 'venue'
             self.columns << :venue
           else
             self.columns << nil
         end
       end
     end
   end

   def map_teams
     away = columns.index(:away_team)
     home = columns.index(:home_team)
     team_names = []
     contents.each_with_index do |row, i|
       if i > 0
         team_names << row[away]
         team_names << row[home]
       end
     end
     team_names.collect! {|x| x.strip}
     team_names.each{|n| puts n}
     puts "#{team_names.uniq.length} unique team names"
     team_names.uniq.each{|n| puts n}
     team_names.uniq.each{|name| self.teams.build(:name => name)}
   end

   def map_venues
     v = columns.index(:venue)
     venue_names = []
     contents.each_with_index do |row, i|
       venue_names << row[v] if i > 0
     end if v
     venue_names.uniq.each{|name| self.venues.build(:name => name)}
   end

   def find_venue_id(name)
     v = venues.with_name(name).first
     v.venue_id if v
   end

   def find_team_id(name)
     t = teams.with_name(name).first
     t.team_id if t
   end
end
