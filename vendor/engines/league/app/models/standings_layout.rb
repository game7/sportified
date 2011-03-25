class StandingsLayout
  include Mongoid::Document
 
  field :name

  referenced_in :site

  validates_presence_of :name
  validates_presence_of :site_id

  embeds_many :columns, :class_name => "StandingsColumn"

  class << self
    def for_site(s)
      id = s.class == Site ? s.id : s
      where(:site_id => id)
    end
  end

end
