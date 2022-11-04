# == Schema Information
#
# Table name: orders
#
#  id                :bigint           not null, primary key
#  abandoned_at      :datetime
#  cancelled_at      :datetime
#  completed_at      :datetime
#  confirmation_code :string
#  email             :string
#  first_name        :string
#  last_name         :string
#  total_price       :decimal(8, 2)
#  uuid              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  payment_intent_id :string
#  session_id        :string
#  tenant_id         :bigint
#  user_id           :bigint
#
# Indexes
#
#  index_orders_on_tenant_id  (tenant_id)
#  index_orders_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (tenant_id => tenants.id)
#  fk_rails_...  (user_id => users.id)
#
class Order < ApplicationRecord
  include Sportified::TenantScoped

  belongs_to :user, optional: true

  has_many :registrations
  alias_attribute :items, :registrations

  validates :uuid, presence: true

  def update_total_price
    self.total_price = self.registrations.all.reduce(0){|sum, reg| sum + reg.price }
    self.session_id = nil
  end

  def update_total_price!
    update_total_price
    save
  end

  def payment_required?
    total_price.present? && total_price > 0
  end  

  def description
    items.collect(&:title).uniq.join(', ').truncate(40)
  end

  def status
    case
    when cancelled_at.present?
      :cancelled
    when abandoned_at.present?
      :abandoned
    when completed_at.present?
      :completed
    else
      :pending
    end
  end

  def pending?
    status == :pending
  end

  def completed?
    status == :completed
  end

  def status_name
    status.to_s.titleize
  end

  def application_fee_in_cents
    self.registrations.all.reduce(0){|sum, reg| sum + reg.application_fee_in_cents }
  end
end
