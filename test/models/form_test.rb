# == Schema Information
#
# Table name: forms
#
#  id              :integer          not null, primary key
#  completed       :boolean          default(FALSE), not null
#  data            :hstore
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  registration_id :integer
#  template_id     :integer
#  tenant_id       :integer
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
