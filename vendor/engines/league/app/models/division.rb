class Division
  include Mongoid::Document
  include Sportified::TenantScoped
 
  field :name
  field :slug

  belongs_to :season

  has_many :teams

  validates :name, presence: true

  before_save do |division|
    division.slug = division.name.parameterize
  end

  scope :with_name, lambda { |name| where(:name => name) }
  scope :with_slug, lambda { |slug| where(:slug => slug) }

end
