class Team
  include Mongoid::Document
  include Sportified::TenantScoped
 
  field :name
  validates :name, presence: true
  
  field :short_name
  field :slug
  field :show_in_standings, :type => Boolean, :default => true
  field :pool, :type => String
  field :seed, :type => Integer
  
  field :primary_color
  field :secondary_color
  field :accent_color
  field :main_colors, :type => Array
  field :custom_colors, :type => Boolean
  
  field :crop_x, :type => Integer, :default => 0
  field :crop_y, :type => Integer, :default => 0
  field :crop_h, :type=> Integer, :default => 0
  field :crop_w, :type => Integer, :default => 0

  def cropping?
    crop_w > 0 && crop_h > 0
  end

  def crop_changed?
    crop_x_changed? || crop_y_changed? || crop_h_changed? || crop_w_changed?
  end
  
  def get_color_palette?
    crop_changed? || logo_changed?
  end

  mount_uploader :logo, TeamLogoUploader

  belongs_to :league
  validates_presence_of :league_id  
  field :league_name
  field :league_slug

  belongs_to :season
  validates_presence_of :season_id
  field :season_name
  field :season_slug

  belongs_to :division
  field :division_name
  field :division_slug

  belongs_to :club

  has_many :players  
  embeds_one :record, :class_name => "Team::Record"

  before_save :set_slug
  def set_slug
    self.slug = self.name.parameterize
  end

  before_save :ensure_short_name
  def ensure_short_name
    if self.short_name.nil? || self.short_name.empty?
      self.short_name = self.name
    end
  end
  
  before_save :ensure_record
  def ensure_record
    self.record ||= Team::Record.new
  end
  
  before_create :set_league_name_and_slug
  def set_league_name_and_slug league = self.league
    self.league_name = league ? league.name : nil
    self.league_slug = league ? league.slug : nil
  end

  before_create :set_season_name_and_slug
  def set_season_name_and_slug season = self.season
    self.season_name = season ? season.name : nil
    self.season_slug = season ? season.slug : nil
  end
  
  before_save :set_division_name
  def set_division_name division = nil
    division ||= Division.find(self.division_id) if self.division_id
    self.division_name = division ? division.name : nil
  end
  
  before_save :clear_crop, :if => :logo_changed?
  def clear_crop
    self.crop_x = 0
    self.crop_y = 0
    self.crop_w = 0
    self.crop_h = 0
  end

  before_save :resize_logo_images, :if => :crop_changed?
  def resize_logo_images
    self.logo.recreate_versions! if self.logo.url
  end
  
  before_save :get_color_palette, :if => :get_color_palette?
  def get_color_palette
    puts 'boo'
    puts 'hoo'
    p = self.logo.color_palette
    self.main_colors = p[:colors]
    unless self.custom_colors
      self.primary_color = p[:primary]
      self.secondary_color = p[:secondary]
      self.accent_color = p[:accent]
    end
  end

  class << self
    def for_league(league)
      league_id = ( league.class == League ? league.id : league )
      where(:league_id => league_id)      
    end
    def for_season(season)
      season_id = ( season.class == Season ? season.id : season )
      where(:season_id => season_id)
    end
  end

  scope :with_slug, lambda { |slug| where(:slug => slug) }
  scope :without_division, where(:division_id => nil)

end
