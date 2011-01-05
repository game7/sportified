class Season
  include Mongoid::Document

  attr_accessible :name, :starts_on, :ends_on, :division_id
  
  key :division_name, :name
  field :name  
  field :slug
  field :division_name
  field :division_slug
  field :league_name
  field :league_slug
  field :starts_on
  field :ends_on

  referenced_in :division, :inverse_of => :seasons
  references_one :current_season, :class_name => "Division"
  references_many :teams

  before_create :set_slug
  before_save :set_slug
  before_create :set_division_and_league_info
  before_save :set_division_and_league_info

  scope :active, where(:starts_on.lt => DateTime.now, :ends_on.gt => DateTime.now)

  private

    def set_slug
      self.slug = self.name.parameterize
    end

    def set_division_and_league_info
      @division = self.division
      if @division
        self.division_name = @division.name
        self.division_slug = @division.slug
        self.league_name = @division.league_name
        self.league_slug = @division.league_slug        
      end
    end

end
