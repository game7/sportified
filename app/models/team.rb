class Team
  include Mongoid::Document

  attr_accessible :name, :short_name
  
  key :division_name, :season_name, :short_name
  field :name
  field :short_name
  field :slug

  field :division_name
  field :division_slug
  field :season_name
  field :season_slug

  referenced_in :season, :inverse_of => :teams
  embeds_many :players

  before_create :set_slug
  before_save :set_slug
  before_create :set_season_and_division_info
  before_save :set_season_and_division_info

  private

    def set_season_and_division_info
      @season = self.season
      if @season
        self.season_name = @season.name
        self.season_slug = @season.slug
        self.division_name = @season.division_name
        self.division_slug = @season.division_slug
      end
    end

    def set_slug
      self.slug = self.name.parameterize
    end

    def ensure_short_name
      if self.short_name.nil? || self.short_name.empty?
        self.short_name = self.name
      end
    end

end
