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
#  customer_id :string
#  token_id    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe CreditCard, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
