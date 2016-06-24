# == Schema Information
#
# Table name: registrar_registrables
#
#  id                      :integer          not null, primary key
#  parent_id               :integer
#  parent_type             :string
#  title                   :string(30)
#  description             :text
#  registrations_allowed   :integer
#  registrations_available :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  tenant_id               :integer
#

class Registrar::Registrable < ActiveRecord::Base
  include Sportified::TenantScoped

  belongs_to :parent, polymorphic: true

  has_many :registration_types

  validates :title, presence: true
  validates :title, length: { maximum: 30 }

  validates :description, presence: true

  validates :registrations_allowed, numericality: { only_integer: true }
  validates :registrations_available, numericality: { only_integer: true }
end
