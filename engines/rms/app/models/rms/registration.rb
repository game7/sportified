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

    # validates :credit_card_id,
    #           presence: true, if: :payment_required?

    validates :price,
              presence: true

    paginates_per 10

    def price_in_cents
      (price * 100).to_i
    end

    def application_fee_in_cents
      [
        (price_in_cents * 0.02).to_i,
        50
      ].max
    end

    def payment_required?
      !price.blank? and price > 0 and payment_id.blank?
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
