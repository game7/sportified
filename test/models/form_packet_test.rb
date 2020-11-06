# == Schema Information
#
# Table name: form_packets
#
#  id         :integer          not null, primary key
#  name       :string(40)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tenant_id  :integer
#
# Indexes
#
#  index_form_packets_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (tenant_id => tenants.id)
#
require 'test_helper'

class FormPacketTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
