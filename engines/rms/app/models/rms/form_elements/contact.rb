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
  class FormElements::Contact < FormElement

    def validate(record)
      if required?
        permitted_params.each do |param|
          puts "#{param}: #{record.data[param].blank?}"
          record.errors.add(param, "Can't be blank") if record.data[param].blank?
        end
      end
      unless record.data["#{name}-email"].blank?
        record.errors.add("#{name}-email", "is not an email address") unless
          record.data["#{name}-email"] =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      end
      record.data["#{name}-phone"] = ActionController::Base.helpers.number_to_phone(record.data["#{name}-phone"])
    end

    def fields
      %w{ first last email phone }
    end

    def permitted_params
      fields.collect{|f| "#{name}-#{f}"}
    end

    def accessors
      permitted_params
    end

  end
end
