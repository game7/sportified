# == Schema Information
#
# Table name: chromecasts
#
#  id                 :integer          not null, primary key
#  name               :string
#  tenant_id          :integer
#  location_id        :integer
#  playing_surface_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
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

  belongs_to :location
  belongs_to :playing_surface

  validates :name, presence: true
end
