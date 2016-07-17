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

require 'rails_helper'

RSpec.describe CreditCardsController, :type => :controller do

end
