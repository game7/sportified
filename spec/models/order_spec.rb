# == Schema Information
#
# Table name: orders
#
#  id                :bigint           not null, primary key
#  abandoned_at      :datetime
#  cancelled_at      :datetime
#  completed_at      :datetime
#  confirmation_code :string
#  email             :string
#  first_name        :string
#  last_name         :string
#  total_price       :decimal(8, 2)
#  uuid              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  payment_intent_id :string
#  session_id        :string
#  tenant_id         :bigint
#  user_id           :bigint
#
# Indexes
#
#  index_orders_on_tenant_id  (tenant_id)
#  index_orders_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (tenant_id => tenants.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Order, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
