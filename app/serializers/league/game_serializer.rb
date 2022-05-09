# == Schema Information
#
# Table name: events
#
#  id                        :integer          not null, primary key
#  all_day                   :boolean
#  description               :text
#  duration                  :integer
#  ends_on                   :datetime
#  exclude_from_team_records :boolean
#  private                   :boolean          default(FALSE), not null
#  starts_on                 :datetime
#  summary                   :string
#  type                      :string
#  created_at                :datetime
#  updated_at                :datetime
#  away_team_locker_room_id  :integer
#  division_id               :integer
#  home_team_locker_room_id  :integer
#  location_id               :integer
#  page_id                   :integer
#  playing_surface_id        :integer
#  program_id                :integer
#  season_id                 :integer
#  tenant_id                 :integer
#
# Indexes
#
#  index_events_on_away_team_locker_room_id  (away_team_locker_room_id)
#  index_events_on_division_id               (division_id)
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
class League::GameSerializer < EventSerializer
  attributes :result_url,
    :statsheet_url,
    :print_scoresheet_url

  def result_url
    edit_admin_game_result_path(object.id)
  end

  def statsheet_url
    edit_admin_game_statsheet_path(object.id)
  end

  def print_scoresheet_url
    print_admin_game_statsheet_path(object.id)
  end
end
