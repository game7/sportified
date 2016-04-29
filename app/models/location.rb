# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  tenant_id  :integer
#  name       :string
#  short_name :string
#  mongo_id   :string
#  created_at :datetime
#  updated_at :datetime
#

class Location < ActiveRecord::Base
  include Sportified::TenantScoped

  has_many :facilities do
    def playing_surfaces
      where(type: 'PlayingSurface')
    end
    def locker_rooms
      where(type: 'LockerRoom')
    end
  end

  validates_presence_of :name

  before_save :ensure_short_name
  def ensure_short_name
    if short_name.nil? || short_name.empty?
      self.short_name = name
    end
  end

end
