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
  class Fields::Text < Field

  end
end
