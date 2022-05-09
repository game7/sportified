# == Schema Information
#
# Table name: league_seasons
#
#  id         :integer          not null, primary key
#  name       :string
#  slug       :string
#  starts_on  :date
#  created_at :datetime
#  updated_at :datetime
#  program_id :integer
#  tenant_id  :integer
#
# Indexes
#
#  index_league_seasons_on_program_id  (program_id)
#
# Foreign Keys
#
#  fk_rails_...  (program_id => programs.id)
#
require 'test_helper'

class League::SeasonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
