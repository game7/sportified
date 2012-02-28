class GameUpload
  include Mongoid::Document
  include Mongoid::Timestamps
  include Sportified::TenantScoped

  field :contents, :type => Array
  validates_presence_of :contents

  referenced_in :season
  field :season_name
  validates_presence_of :season_id
  before_save do |upload|
    upload.season_name = upload.season.name
  end

  field :columns, :type => Array, :default => []

  embeds_many :team_maps
  accepts_nested_attributes_for :team_maps

  embeds_many :venue_maps
  accepts_nested_attributes_for :venue_maps

  field :ready, :type => Boolean, :default => false
  field :completed, :type => Boolean, :default => false

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
    team_maps.each{|t| return false unless t.team_id.present?}
    true
  end

  def venues_ready?
    venue_maps.each{|v| return false unless v.venue_id.present?}
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
          when 'left', 'left_team', 'away', 'away_team'
            self.columns << :left_team
          when 'left_score', 'away_score'
            self.columns << :left_score
          when 'right', 'right_team', 'home', 'home_team'
            self.columns << :right_team
          when 'right_score', 'home_score'
            self.columns << :right_score
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
    l = columns.index(:left_team)
    r = columns.index(:right_team)
    teams = []
    contents.each_with_index do |row, i|
      if i > 0
        teams << row[l]
        teams << row[r]
      end
    end
    teams.collect! {|x| x.strip!}
    puts "#{teams.uniq.length} unique teams"
    teams.uniq.each{|team| self.team_maps.build(:name => team)}
  end

  def map_venues
    v = columns.index(:venue)
    venues = []
    contents.each_with_index do |row, i| 
      venues << row[v] if i > 0
    end
    puts "#{venues.uniq.length} unique venues"
    venues.uniq.each{|venue| self.venue_maps.build(:name => venue)}
  end

  def find_venue_id(name)
    v = venue_maps.with_name(name).first
    v.venue_id if v
  end

  def find_team_id(name)
    t = team_maps.with_name(name).first
    t.team_id if t
  end


end