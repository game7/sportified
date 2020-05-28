# == Schema Information
#
# Table name: form_elements
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
#  index_form_elements_on_template_id_and_name  (template_id,name) UNIQUE
#  index_form_elements_on_tenant_id             (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (template_id => form_templates.id)
#  fk_rails_...  (tenant_id => tenants.id)
#

class FormElements::Address < FormElement

  def self.model_name
    FormElement.model_name
  end    

  def validate(record)
    if required?
      permitted_params.select{|p| p !~ /street2/}.each do |param|
        record.errors.add(param, "Can't be blank") if record.data[param].blank?
      end
    end
  end

  def fields
    %w{ street street2 city state postal }
  end

  def permitted_params
    fields.collect{|f| "#{name}-#{f}"}
  end

  def accessors
    permitted_params
  end

end