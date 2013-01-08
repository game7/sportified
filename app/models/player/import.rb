class Player::Import
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
   
   belongs_to :league
   field :league_name
   validates_presence_of :league_id
   before_save do |import|
     import.league_name = import.league.name
   end
      
   field :columns, :type => Array, :default => []

   embeds_many :teams, class_name: 'Map::Team'
   accepts_nested_attributes_for :teams

   field :ready, :type => Boolean, :default => false
   field :completed, :type => Boolean, :default => false
   
   before_create :map_contents
   def map_contents
     map_columns
     map_teams
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
     teams_ready?
   end

   def teams_ready?
     teams.each{|t| return false unless t.team_id.present?}
     true
   end

   def map_columns
     if contents[0]
       contents[0].each do |col|
         case col
           when 'team_name', 'team'
             self.columns << :team
           when 'jersey', 'jersey_num', 'num'
             self.columns << :jersey_num
           when 'first', 'first_name', 'part_fname'
             self.columns << :first_name
           when 'last', 'last_name', 'part_lname'
             self.columns << :last_name
           when 'birthdate', 'dob'
             self.columns << :birthdate 
           when 'email', 'email_address'
             self.columns << :email                         
           else
             self.columns << nil
         end
       end
     end
   end

   def map_teams
     team = columns.index(:team)
     team_names = []
     contents.each_with_index do |row, i|
       name = row[team]
       name = name.strip
       team_names << name unless i == 0 or team_names.include? name
     end
     team_names.each{|name| self.teams.build(:name => name)}
   end

   def find_team_id(name)
     t = teams.with_name(name).first
     t.team_id if t
   end
   
end
