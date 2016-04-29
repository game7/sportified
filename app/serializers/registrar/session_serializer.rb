# == Schema Information
#
# Table name: registrar_sessions
#
#  id                      :integer          not null, primary key
#  registrable_id          :integer
#  registrable_type        :string
#  title                   :string(30)
#  description             :text
#  registrations_allowed   :integer
#  registrations_available :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class Registrar::SessionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :registrations_allowed, :registrations_available
  has_one :registrable
end
