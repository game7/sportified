class Team
  include Mongoid::Document

  attr_accessible :_id, :name, :short_name
  
  field :name
  field :short_name
  field :slug
  field :id_path, :type => Array
  field :name_path, :type => Array
  field :slug_path, :type => Array

  referenced_in :season, :inverse_of => :teams
  references_many :players
  references_many :games, :inverse_of => :home_team
  references_many :games, :inverse_of => :away_team

  before_save :set_slug
  before_save :set_paths
  before_save :ensure_short_name

  scope :with_slugs, lambda { |slugs| all_in(:slug_path => slugs) }

  private

    def ensure_short_name
      if self.short_name.nil? || self.short_name.empty?
        self.short_name = self.name
      end
    end

    def set_slug
      self.slug = self.name.parameterize
    end

    def set_paths
      @parent = self.season
      self.id_path = @parent.id_path << self.id
      self.name_path = @parent.name_path << self.name 
      self.slug_path = @parent.slug_path << self.slug
    end

end
