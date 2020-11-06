# == Schema Information
#
# Table name: products
#
#  id                 :integer          not null, primary key
#  active             :boolean
#  description        :text
#  private            :boolean
#  quantity_allowed   :integer
#  quantity_available :integer
#  registrable_type   :string
#  roster             :boolean
#  summary            :text
#  title              :string(40)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  registrable_id     :integer
#  tenant_id          :integer
#
# Indexes
#
#  index_products_on_registrable_type_and_registrable_id  (registrable_type,registrable_id)
#  index_products_on_tenant_id                            (tenant_id)
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
  
  has_many :pending_registrations, -> { where(completed_at: nil, cancelled_at: nil, abandoned_at: nil) }, class_name: 'Registration', through: :variants, source: :registrations
  has_many :completed_registrations, -> { where.not(completed_at: nil) }, class_name: 'Registration', through: :variants, source: :registrations
  has_many :cancelled_registrations, -> { where.not(cancelled_at: nil) }, class_name: 'Registration', through: :variants, source: :registrations
  has_many :abandoned_registrations, -> { where.not(abandoned_at: nil) }, class_name: 'Registration', through: :variants, source: :registrations

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

  def event?
    registrable && registrable_type == 'Event'
  end

  def full_title
    puts '----------------------------------------'
    puts self.id
    puts registrable
    puts '----------------------------------------'

     event? ? "#{title} - #{registrable&.starts_at.strftime('%a %-m/%-e %-l:%M %P')}" : title
  end

  scope :active, -> { where(active: true) }
    
end
