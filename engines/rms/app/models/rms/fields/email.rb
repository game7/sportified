# == Schema Information
#
# Table name: rms_fields
#
#  id         :integer          not null, primary key
#  form_id    :integer
#  name       :string(40)
#  position   :integer
#  settings   :hstore
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string
#  required   :boolean
#

module Rms
  class Fields::Email < Field

    def validate(record)
      super(record)
      record.errors.add(name, "is not an email address") unless
        record.data[name] =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    end
  end
end
