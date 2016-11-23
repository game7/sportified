# == Schema Information
#
# Table name: rms_registrations
#
#  id             :integer          not null, primary key
#  tenant_id      :integer
#  user_id        :integer
#  variant_id     :integer
#  credit_card_id :integer
#  first_name     :string(40)
#  last_name      :string(40)
#  email          :string
#  payment_id     :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  price          :decimal(20, 4)
#  form_packet_id :integer
#

module Rms
  class Registration < ActiveRecord::Base
    include Sportified::TenantScoped

    belongs_to :variant
    has_one :item, through: :variant

    has_many :forms
    accepts_nested_attributes_for :forms

    belongs_to :user
    belongs_to :credit_card

    validates :user,
              presence: true

    validates :item,
              presence: true

    validates :email,
              presence: true,
              email: true,
              length: { maximum: 100 }

    # validates :credit_card_id,
    #           presence: true, if: :payment_required?

    validates :price,
              presence: true

    def payment_required?
      variant.present? and variant.price.present? and variant.price > 0
    end

    before_validation :set_price_from_variant

    private

      def set_price_from_variant
        self.price = self.variant.price if self.price.blank? and self.variant.present?
      end

  end
end
