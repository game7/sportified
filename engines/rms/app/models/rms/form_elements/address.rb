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

module Rms
  class FormElements::Address < FormElement

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
end
