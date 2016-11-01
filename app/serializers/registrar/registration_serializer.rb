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
#  payment_id           :string
#

class Registrar::RegistrationSerializer < ActiveModel::Serializer
  attributes :id
end
