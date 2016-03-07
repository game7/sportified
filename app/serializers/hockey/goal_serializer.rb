# == Schema Information
#
# Table name: hockey_goals
#
#  id                      :integer          not null, primary key
#  tenant_id               :integer
#  statsheet_id            :integer
#  period                  :integer
#  minute                  :integer
#  second                  :integer
#  team_id                 :integer
#  scored_by_id            :integer
#  scored_on_id            :integer
#  assisted_by_id          :integer
#  also_assisted_by_id     :integer
#  strength                :string(255)
#  mongo_id                :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  scored_by_number        :string(255)
#  assisted_by_number      :string(255)
#  also_assisted_by_number :string(255)
#

class Hockey::GoalSerializer < ActiveModel::Serializer
  type 'hockey/goals'
  attributes :id, :period, :minute, :second
  belongs_to :team
  belongs_to :scored_by
  belongs_to :assisted_by
  belongs_to :also_assisted_by
end
