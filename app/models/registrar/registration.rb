# == Schema Information
#
# Table name: registrar_registrations
#
#  id                   :integer          not null, primary key
#  tenant_id            :integer
#  user_id              :integer
#  first_name           :string
#  last_name            :string
#  email                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  registration_type_id :integer
#  credit_card_id       :integer
#

class Registrar::Registration < ActiveRecord::Base
  include Sportified::TenantScoped

  belongs_to :registration_type

  has_one :registrable, through: :registration_type

  belongs_to :credit_card

  belongs_to :user

  validates :user,
            presence: true

  validates :registrable,
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
    registration_type.present? and registration_type.price.present? and registration_type.price > 0
  end

end
