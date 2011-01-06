class Season
  include Mongoid::Document

  attr_accessible :name, :starts_on, :ends_on, :division_id
  
  field :name  
  field :slug
  field :id_path, :type => Array
  field :name_path, :type => Array
  field :slug_path, :type => Array
  field :starts_on
  field :ends_on

  referenced_in :division, :inverse_of => :seasons
  references_one :current_season, :class_name => "Division"
  references_many :teams
  references_many :games

  scope :active, where(:starts_on.lt => DateTime.now, :ends_on.gt => DateTime.now)

  before_save :set_slug
  before_save :set_paths

  private

    def set_slug
      self.slug = self.name.parameterize
    end

    def set_paths
      @parent = self.division
      self.id_path = @parent.id_path << self.id
      self.name_path = @parent.name_path << self.name 
      self.slug_path = @parent.slug_path << self.slug
    end

end
