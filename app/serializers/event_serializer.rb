# == Schema Information
#
# Table name: events
#
#  id                        :integer          not null, primary key
#  all_day                   :boolean
#  away_team_custom_name     :boolean
#  away_team_name            :string
#  away_team_score           :integer          default(0)
#  completion                :string
#  description               :text
#  duration                  :integer
#  ends_on                   :datetime
#  exclude_from_team_records :boolean
#  home_team_custom_name     :boolean
#  home_team_name            :string
#  home_team_score           :integer          default(0)
#  private                   :boolean          default(FALSE), not null
#  result                    :string
#  starts_on                 :datetime
#  statsheet_type            :string
#  summary                   :string
#  text_after                :string
#  text_before               :string
#  type                      :string
#  created_at                :datetime
#  updated_at                :datetime
#  away_team_id              :integer
#  away_team_locker_room_id  :integer
#  division_id               :integer
#  home_team_id              :integer
#  home_team_locker_room_id  :integer
#  location_id               :integer
#  page_id                   :integer
#  playing_surface_id        :integer
#  program_id                :integer
#  season_id                 :integer
#  statsheet_id              :integer
#  tenant_id                 :integer
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
  include Rails.application.routes.url_helpers

  attributes :id,
    :tenant_id,
    :division_id,
    :season_id,
    :location_id,
    :type,
    :starts_on,
    :ends_on,
    :duration,
    :all_day,
    :summary,
    :description,
    :created_at,
    :updated_at,
    :home_team_id,
    :away_team_id,
    :statsheet_id,
    :statsheet_type,
    :home_team_score,
    :away_team_score,
    :home_team_name,
    :away_team_name,
    :home_team_custom_name,
    :away_team_custom_name,
    :text_before,
    :text_after,
    :result,
    :completion,
    :exclude_from_team_records,
    :playing_surface_id,
    :home_team_locker_room_id,
    :away_team_locker_room_id,
    :program_id,
    :page_id,
    :private,
    :edit_url,
    :clone_url,
    :delete_url

    def edit_url
      edit_polymorphic_path([:admin, object.module_name, object])
    end

    def clone_url
      new_polymorphic_path([:admin, object.module_name, object.class], :clone => object.id)
    end

    def delete_url
      admin_event_path(object)
    end


end
