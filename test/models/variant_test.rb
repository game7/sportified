# == Schema Information
#
# Table name: variants
#
#  id               :integer          not null, primary key
#  description      :text
#  display_order    :integer          default(0)
#  price            :decimal(20, 4)
#  quantity_allowed :integer
#  title            :string(40)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  form_packet_id   :integer
#  product_id       :integer
#  tenant_id        :integer
#
# Indexes
#
#  index_variants_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (form_packet_id => form_packets.id)
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (tenant_id => tenants.id)
#
require 'test_helper'

class VariantTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
