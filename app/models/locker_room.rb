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

class LockerRoom < Facility

  belongs_to :playing_surface, foreign_key: 'parent_id'

  alias_attribute :playing_surface_id, :parent_id

  validates :playing_surface_id, presence: true

  def preferences
    ['HOME', 'AWAY']
  end

end
