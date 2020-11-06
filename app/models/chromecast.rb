# == Schema Information
#
# Table name: chromecasts
#
#  id                 :integer          not null, primary key
#  name               :string
#  refreshed_at       :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  location_id        :integer
#  playing_surface_id :integer
#  tenant_id          :integer
#
# Indexes
#
#  index_chromecasts_on_location_id         (location_id)
#  index_chromecasts_on_playing_surface_id  (playing_surface_id)
#  index_chromecasts_on_tenant_id           (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#  fk_rails_...  (playing_surface_id => facilities.id)
#  fk_rails_...  (tenant_id => tenants.id)
#
class Chromecast < ApplicationRecord
  include Sportified::TenantScoped

  belongs_to :location, required: false
  belongs_to :playing_surface, required: false

  validates :name, presence: true
end
