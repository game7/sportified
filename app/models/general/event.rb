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
#  recurrence_id             :bigint
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
#  index_events_on_recurrence_id             (recurrence_id)
#  index_events_on_season_id                 (season_id)
#  index_events_on_tenant_id                 (tenant_id)
#
# Foreign Keys
#
#  fk_rails_...  (page_id => pages.id)
#  fk_rails_...  (program_id => programs.id)
#  fk_rails_...  (recurrence_id => recurrences.id)
#
class General::Event < ::Event
  validates :summary, presence: true

  belongs_to :recurrence, optional: true

  after_create do
    recurrence&.create_event_occurrences
  end

  accepts_nested_attributes_for :recurrence, reject_if: proc { |attributes| attributes['ending'].blank? }

  def color_key
    tags.reduce([]) { |result, tag| result.push(tag.name) }.join('-')
  end

  def show_teams?
    home_team_name.present? || away_team_name.present?
  end

  def dup
    super.tap do |clone|
      clone.tag_list = tag_list
    end
  end
end
