# == Schema Information
#
# Table name: registrar_registration_types
#
#  id                   :integer          not null, primary key
#  tenant_id            :integer
#  registrar_session_id :integer
#  title                :string(30)
#  description          :text
#  price                :decimal(20, 4)
#  quantity_allowed     :integer
#  quantity_available   :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

module Registrar::RegistrationTypesHelper
end
