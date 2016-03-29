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

require 'rails_helper'

RSpec.describe PlayingSurface, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
