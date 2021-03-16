# == Schema Information
#
# Table name: vouchers
#
#  id              :bigint           not null, primary key
#  amount          :integer
#  cancelled_at    :datetime
#  consumed_at     :datetime
#  expires_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  registration_id :bigint
#  user_id         :bigint
#
# Indexes
#
#  index_vouchers_on_registration_id  (registration_id)
#  index_vouchers_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (registration_id => registrations.id)
#  fk_rails_...  (user_id => users.id)
#
require 'test_helper'

class VoucherTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
