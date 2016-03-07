# == Schema Information
#
# Table name: hockey_goaltenders
#
#  id                       :integer          not null, primary key
#  type                     :string(255)
#  tenant_id                :integer
#  team_id                  :integer
#  player_id                :integer
#  statsheet_id             :integer
#  games_played             :integer          default(0)
#  minutes_played           :integer          default(0)
#  shots_against            :integer          default(0)
#  goals_against            :integer          default(0)
#  saves                    :integer          default(0)
#  save_percentage          :float            default(0.0)
#  goals_against_average    :float            default(0.0)
#  shutouts                 :integer          default(0)
#  shootout_attempts        :integer          default(0)
#  shootout_goals           :integer          default(0)
#  shootout_save_percentage :float            default(0.0)
#  regulation_wins          :integer          default(0)
#  regulation_losses        :integer          default(0)
#  overtime_wins            :integer          default(0)
#  overtime_losses          :integer          default(0)
#  shootout_wins            :integer          default(0)
#  shootout_losses          :integer          default(0)
#  total_wins               :integer          default(0)
#  total_losses             :integer          default(0)
#  mongo_id                 :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  jersey_number            :string(255)
#  first_name               :string(255)
#  last_name                :string(255)
#

class Hockey::GoaltenderSerializer < ActiveModel::Serializer
  attributes :id, :jersey_number, :first_name, :last_name
  belongs_to :player
end
