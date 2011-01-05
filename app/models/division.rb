class Division
  include Mongoid::Document

  attr_accessible :name, :league_id, :current_season_id
  
  field :name
  field :slug

  references_many :seasons

  field :current_season_name
  referenced_in :current_season, :class_name => "Season"

  before_save :set_slug
  before_save :set_current_season_name
  before_save :set_current_season_id

  private

    def set_slug
      self.slug = self.name.parameterize
    end

    def set_current_season_name
      @current_season = self.current_season
      self.current_season_name = @current_season ? @current_season.name : nil
    end

    def set_current_season_id
      self.current_season_id = nil if self.current_season_id = ''     
    end

end
