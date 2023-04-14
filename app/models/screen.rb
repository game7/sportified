# == Schema Information
#
# Table name: screens
#
#  id                 :bigint           not null, primary key
#  device_key         :string
#  name               :string
#  refreshed_at       :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  location_id        :bigint
#  playing_surface_id :bigint
#  tenant_id          :bigint
#
# Indexes
#
#  index_screens_on_location_id         (location_id)
#  index_screens_on_playing_surface_id  (playing_surface_id)
#  index_screens_on_tenant_id           (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#  fk_rails_...  (playing_surface_id => facilities.id)
#  fk_rails_...  (tenant_id => tenants.id)
#
class Screen < ApplicationRecord
  include Sportified::TenantScoped

  belongs_to :tenant
  belongs_to :location, optional: true
  belongs_to :playing_surface, optional: true

  has_many :screen_locations, dependent: :destroy
  has_many :locations, through: :screen_locations

  validates :name, presence: true
  validates :device_key,
            presence: true,
            format: {
              with: /[A-F0-9]{6}/,
              message: 'is not a valid device key'
            }

  before_validation :upcase_device_key

  def upcase_device_key
    self.device_key = device_key.upcase
  end
end
