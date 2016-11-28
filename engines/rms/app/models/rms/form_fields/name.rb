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
  class FormFields::Name < FormField

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
