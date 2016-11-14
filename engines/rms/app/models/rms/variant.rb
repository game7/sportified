module Rms
  class Variant < ActiveRecord::Base
    include Sportified::TenantScoped

    belongs_to :item

    has_many :registrations, dependent: :destroy

    validates :title,
              presence: true,
              length: { maximum: 30 }

    validates :description, presence: true

    validates :quantity_allowed,
              numericality: { only_integer: true, greater_than_or_equal_to: 0 },
              :allow_nil => true

    validates :quantity_available,
              numericality: { only_integer: true, greater_than_or_equal_to: 0 },
              :allow_nil => true

    validates :price,
              numericality: { greater_than_or_equal_to: 0 },
              :allow_nil => true

    before_create :set_quantity_available_to_quantity_allowed

    def set_quantity_available_to_quantity_allowed
      self.quantity_available = self.quantity_allowed
    end

  end
end
