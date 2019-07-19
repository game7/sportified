# == Schema Information
#
# Table name: rms_form_templates
#
#  id         :integer          not null, primary key
#  tenant_id  :integer
#  packet_id  :integer
#  name       :string(40)
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_rms_form_templates_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (packet_id => rms_form_packets.id)
#  fk_rails_...  (tenant_id => tenants.id)
#

module Rms
  module FormTemplatesHelper
  end
end
