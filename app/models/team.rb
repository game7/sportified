class Team
  include Mongoid::Document

  attr_accessible :_id, :name, :short_name
  
  field :name
  field :short_name
  field :slug

  referenced_in :season, :inverse_of => :teams
  references_many :players

  before_save :set_slug

  private

    def set_slug
      self.slug = self.name.parameterize
    end

end
