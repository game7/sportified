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

    def payment_required?
      variant.present? and variant.price.present? and variant.price > 0
    end

    def entry_required?
      item.form.present?
    end
    
  end
end
