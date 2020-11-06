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
#  index_programs_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (tenant_id => tenants.id)
#
class League::Program < Program
  has_many :seasons
  has_many :divisions
  has_many :events
end
