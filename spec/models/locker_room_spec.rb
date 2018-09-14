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
#  fk_rails_...  (location_id => locations.id)
#

require 'rails_helper'

RSpec.describe LockerRoom, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
