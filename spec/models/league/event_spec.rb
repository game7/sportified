# == Schema Information
#
# Table name: events
#
#  id                        :integer          not null, primary key
#  tenant_id                 :integer
#  division_id               :integer
#  season_id                 :integer
#  location_id               :integer
#  type                      :string
#  starts_on                 :datetime
#  ends_on                   :datetime
#  duration                  :integer
#  all_day                   :boolean
#  summary                   :string
#  description               :text
#  mongo_id                  :string
#  created_at                :datetime
#  updated_at                :datetime
#  home_team_id              :integer
#  away_team_id              :integer
#  statsheet_id              :integer
#  statsheet_type            :string
#  home_team_score           :integer          default(0)
#  away_team_score           :integer          default(0)
#  home_team_name            :string
#  away_team_name            :string
#  home_team_custom_name     :boolean
#  away_team_custom_name     :boolean
#  text_before               :string
#  text_after                :string
#  result                    :string
#  completion                :string
#  exclude_from_team_records :boolean
#  playing_surface_id        :integer
#  home_team_locker_room_id  :integer
#  away_team_locker_room_id  :integer
#  program_id                :integer
#

require 'rails_helper'

RSpec.describe League::Event, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
