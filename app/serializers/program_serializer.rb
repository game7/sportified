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
# Indexes
#
#  index_programs_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_3e00a094b5  (tenant_id => tenants.id)
#

class ProgramSerializer < ActiveModel::Serializer
  type :program
  attributes :id, :name, :description, :created_at, :updated_at, :slug
end
