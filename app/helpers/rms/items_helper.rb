# == Schema Information
#
# Table name: rms_items
#
#  id                 :integer          not null, primary key
#  parent_id          :integer
#  parent_type        :string
#  title              :string(40)
#  description        :text
#  quantity_allowed   :integer
#  quantity_available :integer
#  tenant_id          :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  active             :boolean
#
# Indexes
#
#  index_rms_items_on_parent_type_and_parent_id  (parent_type,parent_id)
#  index_rms_items_on_tenant_id                  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (tenant_id => tenants.id)
#

module Rms
  module ItemsHelper
  end
end
