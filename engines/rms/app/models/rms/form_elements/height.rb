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
  class FormElements::Height < FormElement

    def options
      ('4'..'6').to_a.collect{|f| ('0'..'11').to_a.collect{|i| "#{f}-#{i}"} }.flatten
    end

  end
end
