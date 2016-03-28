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

module Registrar::SessionsHelper
end
