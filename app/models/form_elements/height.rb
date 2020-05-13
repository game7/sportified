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

class FormElements::Height < FormElement

  def self.model_name
    FormElement.model_name
  end    

  def options
    ('4'..'6').to_a.collect{|f| ('0'..'11').to_a.collect{|i| "#{f}-#{i}"} }.flatten
  end

end
