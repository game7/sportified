# == Schema Information
#
# Table name: products
#
#  id                 :integer          not null, primary key
#  active             :boolean
#  description        :text
#  private            :boolean
#  private_token      :string
#  quantity_allowed   :integer
#  quantity_available :integer
#  registrable_type   :string
#  roster             :boolean
#  summary            :text
#  title              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  registrable_id     :integer
#  tenant_id          :integer
#
# Indexes
#
#  index_products_on_registrable_type_and_registrable_id  (registrable_type,registrable_id)
#  index_products_on_tenant_id                            (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (tenant_id => tenants.id)
#
require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
