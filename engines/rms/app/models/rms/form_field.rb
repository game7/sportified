# == Schema Information
#
# Table name: rms_form_fields
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

module Rms
  class FormField < ActiveRecord::Base
    include Sportified::TenantScoped

    belongs_to :template, class_name: 'Rms::FormTemplate'

    validates :name, presence: true
    validates :type, presence: true
    validates :position, presence: true,
                         numericality: { only_integer: true }

    def partial
      self.class.name.split('::').last.downcase
    end

    def validate(record)
        record.errors.add(name, "Can't be blank") if required? and record.data[name].blank?
    end

    def permitted_params
      [ self.name ]
    end

    def accessors
      [ self.name ]
    end

  end
end
