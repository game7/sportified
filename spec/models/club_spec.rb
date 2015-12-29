# == Schema Information
#
# Table name: clubs
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  short_name :string(255)
#  tenant_id  :integer
#  mongo_id   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Club, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
