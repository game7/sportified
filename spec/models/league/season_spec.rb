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
# Indexes
#
#  index_league_seasons_on_program_id  (program_id)
#
# Foreign Keys
#
#  fk_rails_43f69705ce  (program_id => programs.id)
#  fk_rails_9ae86e9659  (program_id => programs.id)
#

require 'rails_helper'

RSpec.describe League::Season, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
