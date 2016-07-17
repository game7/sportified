# == Schema Information
#
# Table name: credit_cards
#
#  id          :integer          not null, primary key
#  tenant_id   :integer
#  user_id     :integer
#  brand       :string(20)
#  country     :string(2)
#  exp_month   :string(2)
#  exp_year    :string(4)
#  funding     :string(10)
#  last4       :string(4)
#  customer_id :integer
#  token_id    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class CreditCard < ActiveRecord::Base
  include Sportified::TenantScoped

  belongs_to :user

  validates :user_id     , presence: true
  validates :brand       , presence: true
  validates :country     , presence: true
  validates :exp_month   , presence: true
  validates :exp_year    , presence: true
  validates :funding     , presence: true
  validates :last4       , presence: true
  validates :customer_id , presence: true
  validates :token_id    , presence: true

  def name
    "#{brand.upcase} ending with #{last4}, expiring #{exp_month}/#{exp_year}"
  end

end
