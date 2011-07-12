class Club
  include Mongoid::Document
  include Sportified::SiteContext

  field :name
  validates_presence_of :name

  field :short_name

  references_many :teams

  before_save :ensure_short_name
  def ensure_short_name
    if self.short_name.nil? || self.short_name.empty?
      self.short_name = self.name
    end
  end

end
