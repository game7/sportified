# == Schema Information
#
# Table name: stripe_connects
#
#  id         :bigint(8)        not null, primary key
#  tenant_id  :bigint(8)
#  referrer   :string
#  token      :string
#  client     :string
#  redirect   :string
#  status     :string
#  result     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_stripe_connects_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (tenant_id => tenants.id)
#

class StripeConnectsController < ApplicationController

  def create
    attrs = {
      referrer: request.referrer,
      client: Tenant.current.stripe_client_id.presence || ENV['STRIPE_CLIENT_ID']
    }
    connect = StripeConnect.new(attrs)
    if connect.save
      redirect_to connect.redirect
    else
      redirect_to request.referrer, flash: { error: 'There seems to have been a problem' }
    end
  end

end
