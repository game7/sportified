class Team
  include Mongoid::Document

  attr_accessible :_id, :name, :short_name
  
  field :name
  field :short_name
  field :slug

  referenced_in :season, :inverse_of => :teams
  references_many :players
  references_many :games, :inverse_of => :home_team
  references_many :games, :inverse_of => :away_team

  before_save :set_slug

  private

    def set_slug
      self.slug = self.name.parameterize
    end

end
