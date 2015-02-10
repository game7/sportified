class Club < ActiveRecord::Base
  include Sportified::TenantScoped

  validates_presence_of :name

  has_many :teams

  before_save :ensure_short_name
  def ensure_short_name
    if self.short_name.nil? || self.short_name.empty?
      self.short_name = self.name
    end
  end
  
end
