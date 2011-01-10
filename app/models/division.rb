class Division
  include Mongoid::Document

  attr_accessible :name, :league_id, :current_season_id
  
  field :name
  field :slugs, :type => Array
  field :breadcrumbs, :type => Array

  references_many :seasons
  
  embeds_one :path

  field :current_season_name
  referenced_in :current_season, :class_name => "Season"

  before_save :set_slugs
  before_save :set_breadcrumbs
  before_save :set_current_season_id
  before_save :set_current_season_name

  private

    def set_slugs
      self.slugs = Array[self.name.parameterize]
    end
    
    def set_breadcrumbs
      self.breadcrumbs = Array[{ :controller => "divisions", :id => self.id, :name => self.name, :slug => self.slug }]
    end

    def set_current_season_name
      @current_season = self.current_season
      self.current_season_name = @current_season ? @current_season.name : nil
    end

    def set_current_season_id
      self.current_season_id = nil if !self.current_season
    end

end
