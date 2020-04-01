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
#  fk_rails_...  (tenant_id => tenants.id)
#

require 'test_helper'

class League::ProgramTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
