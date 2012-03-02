class League
  include Mongoid::Document
  include Sportified::TenantScoped
  
  field :name, :type => String
  validates :name, presence: true
  
  field :slug, :type => String
  
  has_and_belongs_to_many :seasons
  
  before_save do |league|
    league.slug = league.name.parameterize    
  end
  
end
