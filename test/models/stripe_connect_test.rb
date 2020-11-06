# == Schema Information
#
# Table name: stripe_connects
#
#  id         :bigint           not null, primary key
#  client     :string
#  redirect   :string
#  referrer   :string
#  result     :string
#  status     :string
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tenant_id  :bigint
#
# Indexes
#
#  index_stripe_connects_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (tenant_id => tenants.id)
#
require 'test_helper'

class StripeConnectTest < ActiveSupport::TestCase
  setup do
    Tenant.current = tenants(:hockey_league_site)
  end

  context :validations do
    should validate_presence_of(:referrer)
    should validate_presence_of(:client)
  end

  context :associations do
    should belong_to(:tenant)
  end

  context :when_creating do
    setup do
      @attrs = {
        referrer: 'http://example.com/referrer',
        client: 'client-id-from-stripe'
      }
    end
    
    should 'generate a secure token' do
      connect = StripeConnect.create @attrs
      assert_not_nil connect.token
    end    
    
    should 'set the status to pending' do
      connect = StripeConnect.create @attrs
      assert_equal 'pending', connect.status
    end  
    
    should 'set redirect url' do
      connect = StripeConnect.create @attrs
      assert_not_nil connect.redirect
    end      

  end
end
