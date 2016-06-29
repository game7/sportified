# == Schema Information
#
# Table name: registrar_registrables
#
#  id                 :integer          not null, primary key
#  parent_id          :integer
#  parent_type        :string
#  title              :string(30)
#  description        :text
#  quantity_allowed   :integer
#  quantity_available :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  tenant_id          :integer
#

module Registrar::RegistrablesHelper
end
