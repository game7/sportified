# == Schema Information
#
# Table name: form_templates
#
#  id         :integer          not null, primary key
#  name       :string(40)
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  packet_id  :integer
#  tenant_id  :integer
#
# Indexes
#
#  index_form_templates_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (packet_id => form_packets.id)
#  fk_rails_...  (tenant_id => tenants.id)
#
require 'test_helper'

class FormTemplateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
