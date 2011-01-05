class Season
  include Mongoid::Document

  attr_accessible :name, :starts_on, :ends_on, :division_id
  
  field :name  
  field :slug
  field :starts_on
  field :ends_on

  referenced_in :division, :inverse_of => :seasons
  references_one :current_season, :class_name => "Division"
  references_many :teams
  references_many :games

  scope :active, where(:starts_on.lt => DateTime.now, :ends_on.gt => DateTime.now)

  before_save :set_slug

  private

    def set_slug
      self.slug = self.name.parameterize
    end

end
