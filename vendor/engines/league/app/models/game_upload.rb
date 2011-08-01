require 'csv'
require 'open-uri'

class GameUpload
  include Mongoid::Document
  include Mongoid::Timestamps
  include Sportified::SiteContext

  mount_uploader :file, GameUploader
  validates_presence_of :file

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

  before_create :load_mappings_from_file
  def load_mappings_from_file
    load_mappings(CSV.parse(open(self.file.path).read))
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

  def load_mappings(array=[])
    map_columns_and_remove_row(array)
    map_teams(array)
    map_venues(array)    
  end

  def map_columns_and_remove_row(arr)
    cols = arr.shift
    cols.each do |col|
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

  def map_teams(arr)
    l = columns.index(:left_team)
    r = columns.index(:right_team)
    teams = []
    arr.each do |row|
      teams << row[l]
      teams << row[r]
    end
    puts "#{teams.uniq.length} unique teams"
    teams.uniq.each{|team| self.team_maps.build(:name => team)}
  end

  def map_venues(arr)
    v = columns.index(:venue)
    venues = []
    arr.each{|row| venues << row[v]}
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
