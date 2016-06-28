# == Schema Information
#
# Table name: registrar_registrables
#
#  id                      :integer          not null, primary key
#  parent_id               :integer
#  parent_type             :string
#  title                   :string(30)
#  description             :text
#  quantity_allowed   :integer
#  quantity_available :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  tenant_id               :integer
#

class Registrar::Registrable < ActiveRecord::Base
  include Sportified::TenantScoped

  belongs_to :parent, polymorphic: true

  has_many :registration_types
  accepts_nested_attributes_for :registration_types, reject_if: :all_blank, allow_destroy: true

  validates :title, presence: true
  validates :title, length: { maximum: 30 }

  validates :description, presence: true

  validates :quantity_allowed, numericality: { only_integer: true }, :allow_nil => true
  validates :quantity_available, numericality: { only_integer: true }, :allow_nil => true

  before_create :set_quantity_available_to_quantity_allowed

  def set_quantity_available_to_quantity_allowed
    self.quantity_available = self.quantity_allowed
  end

end
