# == Schema Information
#
# Table name: league_seasons
#
#  id         :integer          not null, primary key
#  name       :string
#  slug       :string
#  starts_on  :date
#  tenant_id  :integer
#  mongo_id   :string
#  created_at :datetime
#  updated_at :datetime
#  program_id :integer
#

require 'rails_helper'

RSpec.describe League::Season, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
