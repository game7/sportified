# == Schema Information
#
# Table name: seasons
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  starts_on  :date
#  tenant_id  :integer
#  mongo_id   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Season, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
