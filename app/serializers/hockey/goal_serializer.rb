# == Schema Information
#
# Table name: hockey_goals
#
#  id                      :integer          not null, primary key
#  also_assisted_by_number :string
#  assisted_by_number      :string
#  minute                  :integer
#  period                  :string
#  scored_by_number        :string
#  second                  :integer
#  strength                :string
#  created_at              :datetime
#  updated_at              :datetime
#  also_assisted_by_id     :integer
#  assisted_by_id          :integer
#  scored_by_id            :integer
#  scored_on_id            :integer
#  statsheet_id            :integer
#  team_id                 :integer
#  tenant_id               :integer
#
# Indexes
#
#  index_hockey_goals_on_statsheet_id  (statsheet_id)
#  index_hockey_goals_on_tenant_id     (tenant_id)
#
class Hockey::GoalSerializer < ActiveModel::Serializer
  type 'hockey/goals'
  attributes :id, :period, :minute, :second, :team_id, :scored_by_id, :assisted_by_id, :also_assisted_by_id, :strength
end
