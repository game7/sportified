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
  class FormElements::Name < FormElement

    def self.model_name
      FormElement.model_name
    end    

    def validate(record)
      if required?
        permitted_params.each do |param|
          record.errors.add(param, "Can't be blank") if record.data[param].blank?
        end
      end
    end

    def permitted_params
      ["#{name}-first","#{name}-last"]
    end

    def accessors
      permitted_params
    end

  end
end
