# == Schema Information
#
# Table name: hockey_penalties
#
#  id                  :integer          not null, primary key
#  tenant_id           :integer
#  statsheet_id        :integer
#  period              :integer
#  minute              :integer
#  second              :integer
#  team_id             :integer
#  committed_by_id     :integer
#  infraction          :string(255)
#  duration            :integer
#  severity            :string(255)
#  start_period        :string(255)
#  start_minute        :integer
#  start_second        :integer
#  end_period          :string(255)
#  end_minute          :integer
#  end_second          :integer
#  mongo_id            :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  committed_by_number :string(255)
#

class Hockey::PenaltySerializer < ActiveModel::Serializer
  type 'hockey/penalties'
  attributes :id, :period, :minute, :second, :infraction, :duration, :severity
  attributes :start_period, :start_minute, :start_second, :end_period, :end_minute, :end_second
  belongs_to :team
  belongs_to :committed_by
end
