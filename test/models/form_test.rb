# == Schema Information
#
# Table name: forms
#
#  id              :integer          not null, primary key
#  tenant_id       :integer
#  registration_id :integer
#  template_id     :integer
#  data            :hstore
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  completed       :boolean          default(FALSE), not null
#
# Indexes
#
#  index_forms_on_tenant_id  (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (registration_id => registrations.id)
#  fk_rails_...  (template_id => form_templates.id)
#  fk_rails_...  (tenant_id => tenants.id)
#

require 'test_helper'

class FormTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
