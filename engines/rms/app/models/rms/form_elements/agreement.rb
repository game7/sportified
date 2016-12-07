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
  class FormElements::Agreement < FormElement

    store_accessor :properties, :terms

    def validate(record)
      puts "#{self.name}: #{record.data[self.name]}"
      record.errors.add(self.name, "Must accept #{self.name}") unless record.data[self.name] == "true"
    end

  end
end
