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

class PlayingSurface < Facility

  has_many :locker_rooms, foreign_key: "parent_id"

end
