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
#  refreshed_at       :datetime
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

require 'rails_helper'

RSpec.describe Chromecast, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
