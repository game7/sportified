# == Schema Information
#
# Table name: registrations
#
#  id                :integer          not null, primary key
#  tenant_id         :integer
#  user_id           :integer
#  variant_id        :integer
#  credit_card_id    :integer
#  first_name        :string(40)
#  last_name         :string(40)
#  email             :string
#  payment_id        :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  price             :decimal(20, 4)
#  form_packet_id    :integer
#  confirmation_code :string
#  birthdate         :date
#  session_id        :text
#  payment_intent_id :text
#  uuid              :string
#
# Indexes
#
#  index_registrations_on_credit_card_id  (credit_card_id)
#  index_registrations_on_tenant_id       (tenant_id)
#  index_registrations_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (credit_card_id => credit_cards.id)
#  fk_rails_...  (form_packet_id => form_packets.id)
#  fk_rails_...  (tenant_id => tenants.id)
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (variant_id => variants.id)
#

class Registration < ApplicationRecord
  include Sportified::TenantScoped

  belongs_to :variant, counter_cache: true
  has_one :product, through: :variant
  has_many :forms, dependent: :destroy
  accepts_nested_attributes_for :forms

  belongs_to :user, required: false

  belongs_to :credit_card, required: false

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
    if variant && variant.quantity_allowed.present? && variant.registrations.length > variant.quantity_allowed
      errors.add(:base, "The option for '#{variant.title}' has reached maximum capacity and is no longer available")
    end
  end

  paginates_per 10

  scope :pending, -> { where('payment_id is null') }
  scope :completed, -> { where('payment_id is not null') }
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
    !self.new_record? and !price.blank? and price > 0 and payment_id.blank?
  end

  def forms_completed?
    forms.all? {|form| form.completed?}
  end

  def completed?
    forms_completed? and (payment_required? ? paid? : true)
  end

  def status
    return 'Completed' if completed?
  end

  def paid?
    !payment_id.blank?
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
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

  before_validation :set_price_from_variant
  before_create :generate_uuid, unless: :uuid
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
  
end
