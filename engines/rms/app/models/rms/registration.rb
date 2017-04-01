# == Schema Information
#
# Table name: rms_registrations
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
#  active            :boolean
#  birthdate         :date
#
# Indexes
#
#  index_rms_registrations_on_credit_card_id  (credit_card_id)
#  index_rms_registrations_on_tenant_id       (tenant_id)
#  index_rms_registrations_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_0d5c6ccd80  (form_packet_id => rms_form_packets.id)
#  fk_rails_aab63f75e7  (user_id => users.id)
#  fk_rails_bb8c231558  (variant_id => rms_variants.id)
#  fk_rails_bf80a14f52  (tenant_id => tenants.id)
#  fk_rails_e8e25427ad  (credit_card_id => credit_cards.id)
#

module Rms
  class Registration < ActiveRecord::Base
    include Sportified::TenantScoped

    belongs_to :variant
    has_one :item, through: :variant

    has_many :forms, dependent: :destroy
    accepts_nested_attributes_for :forms

    belongs_to :user
    belongs_to :credit_card

    validates :variant,
              presence: true

    validates :user,
              presence: true

    validates :item,
              presence: true

    validates :first_name,
              presence: true,
              length: { maximum: 40 }

    validates :last_name,
              presence: true,
              length: { maximum: 40 }

    validates :email,
              presence: true,
              email: true,
              length: { maximum: 100 }

    validates :birthdate,
              presence: true

    validates :credit_card_id,
              presence: true,
              if: :payment_required?

    validates :price,
              presence: true

    paginates_per 10

    scope :pending, -> { where('payment_id is null') }
    scope :completed, -> { where('payment_id is not null') }
    scope :created_on_or_after, ->(date) { where('rms_registrations.created_at >= ?', date)}

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

    def paid?
      !payment_id.blank?
    end

    def full_name
      "#{self.first_name} #{self.last_name}"
    end

    before_validation :set_price_from_variant
    before_save :generate_confiramtion_code, unless: "confirmation_code?"

    private

      def set_price_from_variant
        self.price = self.variant.price if self.price.blank? and self.variant.present?
      end

      def generate_confiramtion_code
        charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
        self.confirmation_code = (0...6).map{ charset.to_a[rand(charset.size)] }.join
      end

  end
end
