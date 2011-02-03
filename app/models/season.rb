class Season
  include Mongoid::Document
  cache

  attr_accessible :name, :starts_on, :ends_on, :division_id
  accepts_nested_attributes_for :standings_columns
  
  field :name  
  field :slug
  field :breadcrumbs, :type => Array
  field :starts_on
  field :ends_on

  referenced_in :division, :inverse_of => :seasons
  references_one :current_season, :class_name => "Division"
  references_many :teams
  references_many :team_records
  references_many :games
  embeds_many :standings_columns, :class_name => "StandingsColumn"

  scope :with_name, lambda { |name| where(:name => name) }
  scope :with_slug, lambda { |slug| where(:slug => slug) }
  scope :active, where(:starts_on.lt => DateTime.now, :ends_on.gt => DateTime.now)

  before_save :set_slug_and_breadcrumbs

  private

    def set_slug_and_breadcrumbs
      @parent = self.division
      self.slug = self.name.parameterize
      self.breadcrumbs = @parent.breadcrumbs.clone << { :controller => "seasons", :id => self.id, :name => self.name, :slug => self.slug }
    end

end
