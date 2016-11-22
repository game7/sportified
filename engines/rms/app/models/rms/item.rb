# == Schema Information
#
# Table name: rms_items
#
#  id                 :integer          not null, primary key
#  parent_id          :integer
#  parent_type        :string
#  title              :string(40)
#  description        :text
#  quantity_allowed   :integer
#  quantity_available :integer
#  tenant_id          :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  form_id            :integer
#

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
