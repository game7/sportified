# == Schema Information
#
# Table name: facilities
#
#  id          :integer          not null, primary key
#  name        :string
#  type        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  location_id :integer
#  tenant_id   :integer
#
# Indexes
#
#  index_facilities_on_location_id  (location_id)
#  index_facilities_on_tenant_id    (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#
class PlayingSurface < Facility
  default_scope { where(type: klass.name) }
end
