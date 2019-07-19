# == Schema Information
#
# Table name: clubs
#
#  id         :integer          not null, primary key
#  name       :string
#  short_name :string
#  tenant_id  :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_clubs_on_tenant_id  (tenant_id)
#

require 'rails_helper'

RSpec.describe Club, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
