# == Schema Information
#
# Table name: programs
#
#  id          :integer          not null, primary key
#  description :text
#  name        :string
#  slug        :string
#  type        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  tenant_id   :integer
#
# Indexes
#
#  index_programs_on_slug       (slug)
#  index_programs_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (tenant_id => tenants.id)
#
class League::ProgramSerializer < ActiveModel::Serializer
  type :league
  attributes :id, :name, :description, :created_at, :updated_at
end
