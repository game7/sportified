# == Schema Information
#
# Table name: vouchers
#
#  id              :bigint           not null, primary key
#  amount          :integer
#  cancelled_at    :datetime
#  comsumed_at     :datetime
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
class Voucher < ApplicationRecord
  belongs_to :user
  belongs_to :registration, required: false
  
  attribute :quantity, :integer, default: 1

  validates :amount, 
    presence: true,
    numericality: { 
      only_integer: true,
      greater_than_or_equal_to: 0 
    }
  validates :quantity, 
    presence: true,
    numericality: { 
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 20
    }                      
  validates :expires_at, presence: true

  scope :available, ->{ where(comsumed_at: nil).where(cancelled_at: nil).where('expires_at > ?', DateTime.now) }

  after_initialize :default_values
  def default_values
    self.expires_at ||= DateTime.parse('9999-12-31 23:59:59')
  end
end
