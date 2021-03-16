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
require 'rails_helper'

RSpec.describe Voucher, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).only_integer }
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).only_integer }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:registration) }
  end
end
