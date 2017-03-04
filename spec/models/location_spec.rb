# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  tenant_id  :integer
#  name       :string
#  short_name :string
#  mongo_id   :string
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_locations_on_tenant_id  (tenant_id)
#

require 'rails_helper'

RSpec.describe Location, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
