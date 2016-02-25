# == Schema Information
#
# Table name: events
#
#  id                        :integer          not null, primary key
#  tenant_id                 :integer
#  league_id                 :integer
#  season_id                 :integer
#  location_id               :integer
#  type                      :string(255)
#  starts_on                 :datetime
#  ends_on                   :datetime
#  duration                  :integer
#  all_day                   :boolean
#  summary                   :string(255)
#  description               :text
#  mongo_id                  :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  home_team_id              :integer
#  away_team_id              :integer
#  statsheet_id              :integer
#  statsheet_type            :string(255)
#  home_team_score           :integer          default(0)
#  away_team_score           :integer          default(0)
#  home_team_name            :string(255)
#  away_team_name            :string(255)
#  home_team_custom_name     :boolean
#  away_team_custom_name     :boolean
#  text_before               :string(255)
#  text_after                :string(255)
#  result                    :string(255)
#  completion                :string(255)
#  exclude_from_team_records :boolean
#
class Api::GameSerializer < ActiveModel::Serializer
  attributes :id, :starts_on, :ends_on, :summary, :result, :completion
end