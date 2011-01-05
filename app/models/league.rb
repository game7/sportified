class League
  include Mongoid::Document

  attr_accessible :name, :sport_id
  
  field :name
  field :slug
  field :sport_name
  referenced_in :sport
  references_many :divisions

  before_save :set_sport_name
  before_create :set_sport_name

  before_save :set_slug
  before_create :set_slug

  private

    def set_slug
      self.slug = self.name.parameterize
    end

    def set_sport_name
      self.sport_name = self.sport.name if self.sport
    end

end
