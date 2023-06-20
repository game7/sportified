# == Schema Information
#
# Table name: form_elements
#
#  id          :integer          not null, primary key
#  hint        :string
#  name        :string(40)
#  position    :integer
#  properties  :hstore
#  required    :boolean
#  type        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  template_id :integer
#  tenant_id   :integer
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
class FormElements::Choice < FormElement
  def self.model_name
    FormElement.model_name
  end

  store_accessor :properties, :options, :allow_multiple

  attribute :options, :string, default: ''
  attribute :allow_multiple, :boolean

  def options_as_list
    options.split(/\r?\n/)
  end

  def allow_multiple
    ['true', true, 1, '1'].include?(super)
  end

  def allow_multiple=(value)
    super ['true', true, 1, '1'].include?(value)
  end

  def validate(record)
    super
    # multi-select returns 1 result even when nothing has been selected
    record.errors.add(name, 'Select at least one option') if allow_multiple && required? && record.try(:data).try(:[],
                                                                                                                  name).length <= 1
  end

  def permitted_params
    allow_multiple ? [name => []] : [name]
  end
end
