# == Schema Information
#
# Table name: registrar_registration_types
#
#  id                 :integer          not null, primary key
#  tenant_id          :integer
#  registrable_id     :integer
#  title              :string(30)
#  description        :text
#  price              :decimal(20, 4)
#  quantity_allowed   :integer
#  quantity_available :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Registrar::RegistrationType < ActiveRecord::Base
  include Sportified::TenantScoped

  belongs_to :registrable

  has_many :registrations

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
