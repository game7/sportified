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
  class FormElements::Choice < FormElement

    store_accessor :properties, :options

    def options
      super || ''
    end

    def options_as_list
      options.split(/\r?\n/)
    end

  end
end
