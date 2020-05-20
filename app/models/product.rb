# == Schema Information
#
# Table name: products
#
#  id                 :integer          not null, primary key
#  parent_id          :integer
#  parent_type        :string
#  title              :string(40)
#  description        :text
#  quantity_allowed   :integer
#  quantity_available :integer
#  tenant_id          :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  active             :boolean
#  summary            :text
#
# Indexes
#
#  index_products_on_parent_type_and_parent_id  (parent_type,parent_id)
#  index_products_on_tenant_id                  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (tenant_id => tenants.id)
#

class Product < ApplicationRecord
  include Sportified::TenantScoped

  belongs_to :registrable, polymorphic: true, required: false

  has_many :variants, dependent: :destroy

  accepts_nested_attributes_for :variants, reject_if: :all_blank, allow_destroy: true

  has_many :registrations, through: :variants

  has_one_attached :image

  validates :title,
            presence: true,
            length: { maximum: 50 }

  validates :quantity_allowed, numericality: { only_integer: true }, :allow_nil => true
  validates :quantity_available, numericality: { only_integer: true }, :allow_nil => true

  before_create :set_quantity_available_to_quantity_allowed

  def set_quantity_available_to_quantity_allowed
    self.quantity_available = self.quantity_allowed
  end

  def dup
    clone = super
    clone.variants << variants.collect(&:dup)
    clone
  end

  scope :active, -> { where(active: true) }
    
end
