# == Schema Information
#
# Table name: screen_locations
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  location_id :bigint           not null
#  screen_id   :bigint           not null
#
# Indexes
#
#  index_screen_locations_on_location_id  (location_id)
#  index_screen_locations_on_screen_id    (screen_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#  fk_rails_...  (screen_id => screens.id)
#
class ScreenLocation < ApplicationRecord
  belongs_to :screen
  belongs_to :location
end
