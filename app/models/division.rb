class Division
  include Mongoid::Document

  attr_accessible :name, :league_id, :current_season_id
  
  field :name
  field :slug
  field :id_path, :type => Array
  field :name_path, :type => Array
  field :slug_path, :type => Array

  references_many :seasons
  
  embeds_one :path

  field :current_season_name
  referenced_in :current_season, :class_name => "Season"

  before_save :set_slug
  before_save :set_paths
  before_save :set_current_season_id
  before_save :set_current_season_name

  private

    def set_slug
      self.slug = self.name.parameterize
    end
    
    def set_paths
      self.id_path = Array[self.id]
      self.name_path = Array[self.name]
      self.slug_path = Array[self.slug]
    end

    def set_current_season_name
      @current_season = self.current_season
      self.current_season_name = @current_season ? @current_season.name : nil
    end

    def set_current_season_id
      self.current_season_id = nil if !self.current_season
    end

end
