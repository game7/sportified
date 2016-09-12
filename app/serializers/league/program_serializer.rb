# == Schema Information
#
# Table name: programs
#
#  id          :integer          not null, primary key
#  tenant_id   :integer
#  type        :string
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string
#

class League::ProgramSerializer < ActiveModel::Serializer
  type :league
  attributes :id, :name, :description, :created_at, :updated_at
end
