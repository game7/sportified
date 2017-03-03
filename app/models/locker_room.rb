# == Schema Information
#
# Table name: facilities
#
#  id          :integer          not null, primary key
#  type        :string
#  name        :string
#  tenant_id   :integer
#  location_id :integer
#  parent_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  preference  :string
#
# Indexes
#
#  index_facilities_on_location_id  (location_id)
#  index_facilities_on_parent_id    (parent_id)
#  index_facilities_on_tenant_id    (tenant_id)
#
# Foreign Keys
#
#  fk_rails_4d0a4ebac5  (location_id => locations.id)
#

class LockerRoom < Facility

  belongs_to :playing_surface, foreign_key: 'parent_id'

  alias_attribute :playing_surface_id, :parent_id

  validates :playing_surface_id, presence: true

  def preferences
    ['HOME', 'AWAY']
  end

end
