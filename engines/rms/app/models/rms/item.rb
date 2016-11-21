module Rms
  class Item < ActiveRecord::Base

    belongs_to :parent, polymorphic: true

    has_many :variants, dependent: :destroy

    accepts_nested_attributes_for :variants, reject_if: :all_blank, allow_destroy: true

    has_many :registrations, through: :variants

    belongs_to :form

    validates :title,
              presence: true,
              length: { maximum: 30 }

    validates :description, presence: true

    validates :quantity_allowed, numericality: { only_integer: true }, :allow_nil => true
    validates :quantity_available, numericality: { only_integer: true }, :allow_nil => true

    before_create :set_quantity_available_to_quantity_allowed

    def set_quantity_available_to_quantity_allowed
      self.quantity_available = self.quantity_allowed
    end

  end

end
