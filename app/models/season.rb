class Season
  include Mongoid::Document
  cache

  attr_accessible :name, :starts_on
  accepts_nested_attributes_for :standings_columns
  
  field :name  
  field :slug
  field :starts_on, :type => Date

  references_and_referenced_in_many :divisions
  references_many :divisions
  references_many :games
  references_many :teams

  validates_presence_of :name, :starts_on

  scope :with_name, lambda { |name| where(:name => name) }
  scope :with_slug, lambda { |slug| where(:slug => slug) }

  before_save :set_slug

  private

    def set_slug
      self.slug = self.name.parameterize
    end

end
