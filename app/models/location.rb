class Location < ActiveRecord::Base
  include Sportified::TenantScoped

  validates_presence_of :name

  before_save :ensure_short_name
  def ensure_short_name
    if short_name.nil? || short_name.empty?
      self.short_name = name
    end
  end

end
