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
#  hint        :string
#
# Indexes
#
#  index_rms_form_elements_on_template_id_and_name  (template_id,name) UNIQUE
#  index_rms_form_elements_on_tenant_id             (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (template_id => rms_form_templates.id)
#  fk_rails_...  (tenant_id => tenants.id)
#

module Rms
  class FormElements::Email < FormElement

    def self.model_name
      FormElement.model_name
    end    

    def validate(record)
      super(record)
      record.errors.add(name, "is not an email address") unless
        record.data[name] =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    end

  end
end
