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
  class FormElement < ActiveRecord::Base
    include Sportified::TenantScoped

    belongs_to :template, class_name: 'Rms::FormTemplate'
    validates :template, presence: true

    validates :name, presence: true
    validates :type, presence: true
    validates :position, presence: true,
                         numericality: { only_integer: true }

    def partial
      self.class.name.split('::').last.downcase
    end

    def validate(record)
      record.errors.add(name, "Can't be blank") if required? and record.try(:data).try(:[], name).blank?
    end

    def permitted_params
      [ self.name ]
    end

    def accessors
      [ self.name ]
    end

    before_save :format_name

    def format_name
      self.name = self.name.parameterize(separator: '_')
    end

  end
end
