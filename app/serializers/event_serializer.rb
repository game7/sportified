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
#  page_id                   :integer
#  private                   :boolean          default(FALSE), not null
#
# Indexes
#
#  index_events_on_away_team_id              (away_team_id)
#  index_events_on_away_team_locker_room_id  (away_team_locker_room_id)
#  index_events_on_division_id               (division_id)
#  index_events_on_home_team_id              (home_team_id)
#  index_events_on_home_team_locker_room_id  (home_team_locker_room_id)
#  index_events_on_location_id               (location_id)
#  index_events_on_page_id                   (page_id)
#  index_events_on_playing_surface_id        (playing_surface_id)
#  index_events_on_program_id                (program_id)
#  index_events_on_season_id                 (season_id)
#  index_events_on_tenant_id                 (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (page_id => pages.id)
#  fk_rails_...  (program_id => programs.id)
#

class EventSerializer < ActiveModel::Serializer
  type :event
  attributes :id, :starts_on, :ends_on, :duration, :description, :summary, :program_id, :location_id, :tags
  has_one :program
  has_one :location
  def tags
    object.taggings.collect{|tagging| tagging.tag_id.to_s }
  end
  def id
    object.id.to_s
  end
end
