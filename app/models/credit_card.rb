# == Schema Information
#
# Table name: credit_cards
#
#  id             :integer          not null, primary key
#  tenant_id      :integer
#  user_id        :integer
#  brand          :string(20)
#  country        :string(2)
#  exp_month      :string(2)
#  exp_year       :string(4)
#  funding        :string(10)
#  last4          :string(4)
#  stripe_card_id :string
#  token_id       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_credit_cards_on_stripe_card_id  (stripe_card_id)
#  index_credit_cards_on_tenant_id       (tenant_id)
#  index_credit_cards_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_069bf994f3  (user_id => users.id)
#  fk_rails_a4103226a4  (tenant_id => tenants.id)
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
  validates :token_id    , presence: true

  def name
    new_record? ? "New Credit Card" : "#{brand.upcase} ending with #{last4} (exp. #{exp_month}-#{exp_year})"
  end

  def short_name
    new_record? ? "New Card" : "#{brand.upcase} -#{last4}"
  end

end
