# == Schema Information
#
# Table name: rms_form_packets
#
#  id         :integer          not null, primary key
#  tenant_id  :integer
#  name       :string(40)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_rms_form_packets_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (tenant_id => tenants.id)
#

module Rms
  module FormPacketsHelper
  end
end
