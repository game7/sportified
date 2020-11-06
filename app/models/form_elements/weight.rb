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
class FormElements::Weight < FormElement
  def self.model_name
    FormElement.model_name
  end

  def validate(record)
    super(record)
    begin
      weight = Integer(record.data[name])
      if weight > 350
        record.errors.add(name, "seems a little too heavy")
      elsif weight < 40
        record.errors.add(name, "doesn't seem heavy enough")
      end
    rescue
      record.errors.add(name, "that's not a number!")
    end
  end
end
