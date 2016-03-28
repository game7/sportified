# == Schema Information
#
# Table name: registrar_sessions
#
#  id                      :integer          not null, primary key
#  tenant_id               :integer
#  registrable_id          :integer
#  registrable_type        :string
#  title                   :string(30)
#  description             :text
#  registrations_allowed   :integer
#  registrations_available :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class Registrar::Session < ActiveRecord::Base
  include Sportified::TenantScoped

  belongs_to :registrable, polymorphic: true

  validates :title, presence: true
  validates :title, length: { maximum: 30 }

  validates :description, presence: true

  validates :registrations_allowed, numericality: { only_integer: true }
  validates :registrations_available, numericality: { only_integer: true }

end
