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
#

module Rms
  class FormFields::Email < FormField

    def validate(record)
      super(record)
      record.errors.add(name, "is not an email address") unless
        record.data[name] =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    end
        
  end
end
