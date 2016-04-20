# == Schema Information
#
# Table name: league_seasons
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  starts_on  :date
#  tenant_id  :integer
#  mongo_id   :string(255)
#  created_at :datetime
#  updated_at :datetime
#  program_id :integer
#

require 'rails_helper'

RSpec.describe League::Season, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
