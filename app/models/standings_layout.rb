class StandingsLayout
  include Mongoid::Document
  include Sportified::SiteContext
 
  field :name
  validates_presence_of :name

  embeds_many :columns, :class_name => "StandingsColumn"


end