# == Schema Information
#
# Table name: variants
#
#  id                 :integer          not null, primary key
#  product_id         :integer
#  tenant_id          :integer
#  title              :string(40)
#  description        :text
#  price              :decimal(20, 4)
#  quantity_allowed   :integer
#  quantity_available :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  form_packet_id     :integer
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
  belongs_to :form_packet, required: false
  has_many :registrations, dependent: :destroy

  validates :title,
            presence: true,
            length: { maximum: 30 }

  validates :quantity_allowed,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 },
            :allow_nil => true

  validates :quantity_available,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 },
            :allow_nil => true

  validates :price,
            numericality: { greater_than_or_equal_to: 0 },
            :allow_nil => true

  before_create :set_quantity_available_to_quantity_allowed

  def set_quantity_available_to_quantity_allowed
    self.quantity_available = self.quantity_allowed
  end    
end
