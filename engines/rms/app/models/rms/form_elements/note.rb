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
  class FormElements::Note < FormElement

    def self.model_name
      FormElement.model_name
    end

    store_accessor :properties, :rows

    def rows
      super || 3
    end

    validates :rows, presence: true,
                     numericality: { integer_only: true }

  end
end
