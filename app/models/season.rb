class Season
  include Mongoid::Document

  attr_accessible :name, :starts_on, :ends_on, :division_id
  
  field :name  
  field :slugs, :type => Array
  field :breadcrumbs, :type => Array
  field :starts_on
  field :ends_on

  referenced_in :division, :inverse_of => :seasons
  references_one :current_season, :class_name => "Division"
  references_many :teams
  references_many :games

  scope :active, where(:starts_on.lt => DateTime.now, :ends_on.gt => DateTime.now)

  before_save :set_slugs_and_breadcrumbs

  private

    def set_slugs_and_breadcrumbs
      @parent = self.division
      self.slugs = @parent.slugs << self.name.parameterize
      self.breadcrumbs = @parent.breadcrumbs << { :controller => "seasons", :id => self.id, :name => self.name, :slug => self.slugs.last }
    end

end
