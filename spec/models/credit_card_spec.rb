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
#  fk_rails_...  (tenant_id => tenants.id)
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe CreditCard, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
