# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  tenant_id  :integer
#  name       :string
#  short_name :string
#  created_at :datetime
#  updated_at :datetime
#  deleted_at :datetime
#
# Indexes
#
#  index_locations_on_deleted_at  (deleted_at)
#  index_locations_on_tenant_id   (tenant_id)
#

class Location < ActiveRecord::Base
  include Sportified::TenantScoped
  acts_as_paranoid

  has_many :facilities do
    def playing_surfaces
      where(type: 'PlayingSurface')
    end
    def locker_rooms
      where(type: 'LockerRoom')
    end
  end
  has_many :playing_surfaces
  has_many :locker_rooms, through: :playing_surfaces

  validates_presence_of :name

  before_save :ensure_short_name
  def ensure_short_name
    if short_name.nil? || short_name.empty?
      self.short_name = name
    end
  end

end
