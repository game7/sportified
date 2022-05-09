# == Schema Information
#
# Table name: registrations
#
#  id                :integer          not null, primary key
#  abandoned_at      :datetime
#  birthdate         :date
#  cancelled_at      :datetime
#  checked_in_at     :datetime
#  completed_at      :datetime
#  confirmation_code :string
#  email             :string
#  first_name        :string(40)
#  last_name         :string(40)
#  price             :decimal(20, 4)
#  uuid              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  form_packet_id    :integer
#  payment_id        :string
#  payment_intent_id :text
#  session_id        :text
#  tenant_id         :integer
#  user_id           :integer
#  variant_id        :integer
#
# Indexes
#
#  index_registrations_on_tenant_id  (tenant_id)
#  index_registrations_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (form_packet_id => form_packets.id)
#  fk_rails_...  (tenant_id => tenants.id)
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (variant_id => variants.id)
#
class Registration < ApplicationRecord
  include Sportified::TenantScoped

  belongs_to :variant
  has_one :product, through: :variant
  has_many :forms, dependent: :destroy
  accepts_nested_attributes_for :forms

  belongs_to :user, required: false

  attribute :voucher_id, :integer

  has_one :voucher

  validates :variant,
            presence: true

  validates :product,
            presence: true

  validates :first_name,
            presence: true,
            length: { maximum: 40 }

  validates :last_name,
            presence: true,
            length: { maximum: 40 }

  validates :email,
            presence: true,
            email: true

  validates :birthdate,
            presence: true

  validate :variant_must_have_quantity_available

  def variant_must_have_quantity_available
    if variant && variant.quantity_allowed.present? && variant.registrations.allocated.length > variant.quantity_allowed
      errors.add(:base, "The option for '#{variant.title}' has reached maximum capacity and is no longer available")
    end
  end

  paginates_per 10

  scope :pending, -> { where(completed_at: nil, abandoned_at: nil, cancelled_at: nil) }
  scope :completed, -> { where.not(completed_at: nil) }
  scope :allocated, -> { where(abandoned_at: nil, cancelled_at: nil) }
  scope :created_on_or_after, ->(date) { where('registrations.created_at >= ?', date)}

  def price_in_cents
    (price * 100).to_i
  end

  def application_fee_in_cents
    [
      (price_in_cents * 0.04).to_i,
      50
    ].max
  end

  def payment_required?
    !self.new_record? && price.present? && price > 0 && payment_id.blank?
  end

  def completed?
    abandoned_at.blank? && cancelled_at.blank? && completed_at.present?
  end

  def status
    case
    when cancelled_at.present?
      'Cancelled'
    when abandoned_at.present?
      'Abandoned'
    when completed_at.present?
      'Completed'
    else
      'Pending'
    end
  end

  def paid?
    payment_id.present?
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def last_name_first_name
    "#{self.last_name}, #{self.first_name}"
  end

  def masked_name
    "#{mask(first_name)} #{mask(last_name)}"
  end

  def test?
    false
  end

  def payment_url
    "https://dashboard.stripe.com#{test? ? '/test' : ''}/payments/#{payment_intent_id}"
  end

  def can_abandon?
    completed_at.blank? && abandoned_at.blank?
  end

  def can_cancel?
    completed_at.present? && cancelled_at.blank?
  end

  def update_status!
    if price.blank? || price == 0 || payment_id.present?
      update_attribute(:completed_at, updated_at)
    end
  end

  before_validation :set_price_from_variant
  before_validation :set_voucher
  before_create :generate_uuid, unless: :uuid
  before_create :mark_completed_if_free
  after_save :touch_product
  before_save :generate_confiramtion_code, unless: :confirmation_code

  private

    def mask(name)
      name[0] + ('*' * (name.length - 1))
    end

    def set_price_from_variant
      self.price = self.variant.price if self.price.blank? and self.variant.present?
    end

    def generate_confiramtion_code
      charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
      self.confirmation_code = (0...6).map{ charset.to_a[rand(charset.size)] }.join
    end

    def generate_uuid
      self.uuid = SecureRandom.uuid
    end

    def mark_completed_if_free
      self.completed_at = created_at if price.blank? || price == 0
    end

    def set_voucher
      if self.voucher_id.present? && voucher = Voucher.find(self.voucher_id)
        self.voucher = voucher
        self.price = [0, self.price - voucher.amount].max
      end
    end

    def touch_product
      self.product.touch
    end
  
end
