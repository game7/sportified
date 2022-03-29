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
require 'rails_helper'

RSpec.describe Screen, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
