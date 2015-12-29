# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  tenant_id  :integer
#  name       :string(255)
#  short_name :string(255)
#  mongo_id   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

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
