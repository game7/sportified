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
class StripeConnect < ApplicationRecord
  include Sportified::TenantScoped

  has_secure_token

  validates :referrer, presence: true
  validates :client, presence: true

  before_create :set_redirect
  before_create :set_status

  scope :pending, ->() { where(status: :pending) }

  private

    def set_redirect
      params = {
        response_type: 'code',
        client_id: self.client,
        state: self.token,
        redirect_uri: Rails.application.credentials.dig(:stripe, :connect, Rails.env, :redirect),
        scope: 'read_write'
      }
      self.redirect = "https://connect.stripe.com/oauth/authorize?#{params.to_query}"
    end

    def set_status
      self.status = :pending
    end

end
