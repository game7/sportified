# == Schema Information
#
# Table name: hockey_goaltenders
#
#  id                       :integer          not null, primary key
#  first_name               :string
#  games_played             :integer          default(0)
#  goals_against            :integer          default(0)
#  goals_against_average    :float            default(0.0)
#  jersey_number            :string
#  last_name                :string
#  minutes_played           :integer          default(0)
#  overtime_losses          :integer          default(0)
#  overtime_wins            :integer          default(0)
#  regulation_losses        :integer          default(0)
#  regulation_wins          :integer          default(0)
#  save_percentage          :float            default(0.0)
#  saves                    :integer          default(0)
#  shootout_attempts        :integer          default(0)
#  shootout_goals           :integer          default(0)
#  shootout_losses          :integer          default(0)
#  shootout_save_percentage :float            default(0.0)
#  shootout_wins            :integer          default(0)
#  shots_against            :integer          default(0)
#  shutouts                 :integer          default(0)
#  total_losses             :integer          default(0)
#  total_wins               :integer          default(0)
#  type                     :string
#  created_at               :datetime
#  updated_at               :datetime
#  player_id                :integer
#  statsheet_id             :integer
#  team_id                  :integer
#  tenant_id                :integer
#
# Indexes
#
#  index_hockey_goaltenders_on_player_id     (player_id)
#  index_hockey_goaltenders_on_statsheet_id  (statsheet_id)
#  index_hockey_goaltenders_on_team_id       (team_id)
#  index_hockey_goaltenders_on_tenant_id     (tenant_id)
#
class Hockey::GoaltenderSerializer < ActiveModel::Serializer
  attributes :id,
    :type,
    :tenant_id,
    :team_id,
    :player_id,
    :statsheet_id,
    :games_played,
    :minutes_played,
    :shots_against,
    :goals_against,
    :saves,
    :save_percentage,
    :goals_against_average,
    :shutouts,
    :shootout_attempts,
    :shootout_goals,
    :shootout_save_percentage,
    :regulation_wins,
    :regulation_losses,
    :overtime_wins,
    :overtime_losses,
    :shootout_wins,
    :shootout_losses,
    :total_wins,
    :total_losses,
    :created_at,
    :updated_at,
    :jersey_number,
    :first_name,
    :last_name

end
