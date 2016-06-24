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

  validates :title, presence: true
  validates :title, length: { maximum: 30 }

  validates :description, presence: true

  validates :quantity_allowed, numericality: { only_integer: true }
  validates :quantity_available, numericality: { only_integer: true }

  validates :price, numericality: { greater_than_or_equal_to: 0 }

end
