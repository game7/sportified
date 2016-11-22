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
#  entry_id       :integer
#  price          :decimal(20, 4)
#

module Rms
  class Registration < ActiveRecord::Base
    belongs_to :tenant
    belongs_to :variant
    has_one :item, through: :variant

    belongs_to :entry
    accepts_nested_attributes_for :entry

    belongs_to :user
    belongs_to :credit_card

    validates :user,
              presence: true

    validates :item,
              presence: true

    validates :first_name,
              presence: true,
              length: { in: 1..20 }

    validates :last_name,
              presence: true,
              length: { in: 1..20 }

    validates :email,
              presence: true,
              email: true,
              confirmation: true,
              length: { maximum: 100 }

    validates :email_confirmation,
              presence: true

    validates :credit_card_id,
              presence: true, if: :payment_required?

    validates :price,
              presence: true

    def payment_required?
      variant.present? and variant.price.present? and variant.price > 0
    end

    def entry_required?
      item.form.present?
    end

    before_validation :set_price_from_variant

    private

      def set_price_from_variant
        self.price = self.variant.price if self.price.blank? and self.variant.present?
      end

  end
end
