# == Schema Information
#
# Table name: rms_form_elements
#
#  id          :integer          not null, primary key
#  tenant_id   :integer
#  template_id :integer
#  type        :string
#  name        :string(40)
#  position    :integer
#  properties  :hstore
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  required    :boolean
#
# Indexes
#
#  index_rms_form_elements_on_template_id_and_name  (template_id,name) UNIQUE
#  index_rms_form_elements_on_tenant_id             (tenant_id)
#
# Foreign Keys
#
#  fk_rails_39849edcea  (template_id => rms_form_templates.id)
#  fk_rails_e12f86d683  (tenant_id => tenants.id)
#

module Rms
  class FormElements::Agreement < FormElement

    store_accessor :properties, :terms

    def validate(record)
      puts "#{self.name}: #{record.data[self.name]}"
      record.errors.add(self.name, "Must accept #{self.name}") unless record.data[self.name] == "true"
    end

  end
end
