# == Schema Information
#
# Table name: registrations
#
#  id                :integer          not null, primary key
#  abandoned_at      :datetime
#  birthdate         :date
#  cancelled_at      :datetime
#  checked_in_at     :datetime
#  completed_at      :datetime
#  confirmation_code :string
#  deleted_at        :datetime
#  email             :string
#  first_name        :string(40)
#  last_name         :string(40)
#  price             :decimal(20, 4)
#  uuid              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  form_packet_id    :integer
#  order_id          :bigint
#  payment_id        :string
#  payment_intent_id :text
#  session_id        :text
#  tenant_id         :integer
#  user_id           :integer
#  variant_id        :integer
#
# Indexes
#
#  index_registrations_on_order_id   (order_id)
#  index_registrations_on_tenant_id  (tenant_id)
#  index_registrations_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (form_packet_id => form_packets.id)
#  fk_rails_...  (tenant_id => tenants.id)
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (variant_id => variants.id)
#
require 'test_helper'

class RegistrationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
