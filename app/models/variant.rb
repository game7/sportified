# == Schema Information
#
# Table name: variants
#
#  id                      :integer          not null, primary key
#  description             :text
#  display_order           :integer          default(0)
#  hide_quantity_available :boolean          default(FALSE)
#  price                   :decimal(20, 4)
#  quantity_allowed        :integer
#  title                   :string(40)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  form_packet_id          :integer
#  product_id              :integer
#  tenant_id               :integer
#
# Indexes
#
#  index_variants_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (form_packet_id => form_packets.id)
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (tenant_id => tenants.id)
#
class Variant < ApplicationRecord
  include Sportified::TenantScoped

  belongs_to :product
  belongs_to :form_packet, optional: true
  has_many :registrations, dependent: :destroy

  validates :title,
            presence: true,
            length: { maximum: 30 }

  validates :quantity_allowed,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 },
            allow_nil: true

  validates :price,
            numericality: { greater_than_or_equal_to: 0 },
            allow_nil: true

  def payment_required?
    price.present?
  end

  def quantity_available
    (quantity_allowed || 100_000) - registrations.allocated.size
  end

  def show_quantity_available?
    quantity_available.present? && !hide_quantity_available?
  end

  delegate :active?, to: :product

  def available?
    product.active? && quantity_available.positive?
  end
end
